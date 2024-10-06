//
//  StatisticsAssembly.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 01.10.2024.
//

import Common
import Domain
import Foundation
import Storage

final class StatisticsAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var useCaseAssembly: UseCaseAssembly = self.context.assembly()
    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    // MARK: - Internal Methods

    func assembleModule(
        coordinator: StatisticsCoordinator
    ) -> StatisticsViewController {
        return define(scope: .prototype, init: StatisticsViewController()) { view in
            view.presenter = self.assemblePresenter(
                view: view,
                coordinator: coordinator,
                storage: self.serviceAssembly.storageService
            )
            return view
        }
    }
}

// MARK: Private Methods

private extension StatisticsAssembly {
    func assemblePresenter(view: StatisticsView, coordinator: StatisticsCoordinator, storage: CoreDataService) -> StatisticsPresenter {
        return define(
            scope: .prototype,
            init: StatisticsViewPresenter(
                view: view,
                coordinator: coordinator,
                storage: storage
            )
        )
    }
}
