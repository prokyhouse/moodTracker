//
//  MainUseCase.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 06.10.2024.
//

import Storage

public protocol MainUseCase {
    func requestMoodReports() -> [MoodNote]
    func requestDeleteMoodReport(id: UUID, completion: @escaping () -> Void)
}

public final class MainUseCaseImpl {
    // MARK: - Public Properties

    // MARK: - Private Properties

    private let coreDataService: CoreDataService

    // MARK: - Lifecycle

    public init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }

}

// MARK: - MainUseCase

extension MainUseCaseImpl: MainUseCase {
    public func requestMoodReports() -> [MoodNote] {
        coreDataService.fetchLastMonthNotes()
    }

    public func requestDeleteMoodReport(id: UUID, completion: @escaping () -> Void) {
        coreDataService.deleteMoodNote(id: id)
        completion()
    }
}
