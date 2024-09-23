//
//  MainAssembly.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//


import Common
import Domain
import Foundation

final class MainAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var useCaseAssembly: UseCaseAssembly = self.context.assembly()
    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    // MARK: - Internal Methods

    func assembleModule(
        coordinator: MainCoordinator
    ) -> MainViewController {
        return define(scope: .prototype, init: MainViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

// MARK: Private Methods

private extension MainAssembly {
    func assemblePresenter(view: MainView, coordinator: MainCoordinator) -> MainPresenter {
        return define(
            scope: .prototype,
            init: MainViewPresenter(
                view: view,
                coordinator: coordinator
            )
        )
    }
}
