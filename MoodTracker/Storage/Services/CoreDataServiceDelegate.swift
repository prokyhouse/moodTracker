//
//  CoreDataServiceDelegate.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//


import Common
import CoreData
import Foundation

public protocol CoreDataServiceDelegate: AnyObject { }

public class CoreDataService {
    // MARK: - Properties
    public static let shared = CoreDataService()

    private let storeType: String

    private(set) var persistentContainer: PersistentContainer!

    public weak var delegate: CoreDataServiceDelegate?

    private(set) var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    private let logger = Common.Logger(category: .database)

    // MARK: - Init

    init(storeType: String = NSSQLiteStoreType) {
        self.storeType = storeType
    }

    // MARK: - Set Up

    public func setup(completion: @escaping (CoreDataService.SetupResult) -> Void) {
        guard
            let container = self.createPersistentContainer()
        else {
            completion(.failed)
            return
        }

        self.persistentContainer = container
        self.mainContext = container.viewContext
        self.mainContext.automaticallyMergesChangesFromParent = true

        self.loadPersistentStore { migrationResult in
            switch migrationResult {
            case .notNeeded, .migrated:
                completion(.success)

            case .failed, .notMigrated:
                completion(.failed)
            }
        }
    }

    // MARK: - Loading

    private func createPersistentContainer() -> PersistentContainer? {
        let bundle = Bundle(for: CoreDataService.self)
        let modelURL = bundle.url(
            forResource: Constants.resourceName,
            withExtension: Constants.resourceExtension
        )

        guard
            let model = modelURL.flatMap(NSManagedObjectModel.init)
        else {
            #if !RELEASE
            logger.log(.error("🗄 Failed to create persistent container"))
            #endif
            return nil
        }

        let persistentContainer = PersistentContainer(
            name: Constants.resourceName,
            managedObjectModel: model
        )
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.shouldInferMappingModelAutomatically = true
        description?.shouldMigrateStoreAutomatically = true
        description?.type = self.storeType
        #if !RELEASE
        logger.log(
            .notice("🗄 Created Persistent Container"),
            .public("URL", value: description?.url)
        )
        #endif
        return persistentContainer
    }

    private func loadPersistentStore(completion: @escaping (MigrationResult) -> Void) {
        self.persistentContainer.loadPersistentStores { [weak logger] description, error in
            if let container = self.persistentContainer {
                self.mainContext = container.viewContext
                self.mainContext.automaticallyMergesChangesFromParent = true
            }
            if error == nil {
                completion(.notNeeded)
                #if !RELEASE
                logger?.log(
                    .notice("🗄 Loaded Persistent Store"),
                    .public("type", value: description.type)
                )
                #endif
                return
            }
            completion(.failed)
        }
    }
}

public extension CoreDataService {
    enum SetupResult {
        /// БД настроена без проблем
        case success

        /// Что-то плохое случилось в процессе миграции БД или ее перезаписи.
        case failed
    }

    enum MigrationResult {
        /// Нет причины начинать миграцию
        case notNeeded

        /// БД успешно мигрировала
        case migrated

        /// БД не смогла мигрировать
        case notMigrated

        /// Что-то плохое случилось в процессе миграции БД или ее перезаписи
        case failed
    }
}

public extension CoreDataService {
    static func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        CoreDataService.shared.persistentContainer.performBackgroundTask(block)
    }

    static func performViewTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        block(CoreDataService.shared.mainContext)
    }

    @discardableResult
    static func saveContext(_ context: NSManagedObjectContext) -> Bool {
        guard context.hasChanges else {
            return false
        }

        do {
            try context.save()
            return true
        } catch {
            #if !RELEASE
            shared.logger.log(
                .error("🗄 Error saving context"),
                .public("error", value: error),
                .public("info", value: (error as NSError).userInfo)
            )
            #endif
            return false
        }
    }

    func drop(_ completionHandler: @escaping (Result<Void, Swift.Error>) -> Void) {
        let coordinator = persistentContainer.persistentStoreCoordinator
        for store in coordinator.persistentStores {
            guard let storeUrl = store.url else { continue }
            do {
                try coordinator.destroyPersistentStore(at: storeUrl, ofType: store.type)
            } catch {
                completionHandler(.failure(error))
                break
            }
        }
        completionHandler(.success(()))
    }
}

// MARK: - Constants

private extension CoreDataService {
    enum Constants {
        static let resourceName: String = "AppModel"
        static let resourceExtension: String = "momd"
    }
}
