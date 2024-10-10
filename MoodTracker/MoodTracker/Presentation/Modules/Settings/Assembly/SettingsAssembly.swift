//
//  SettingsAssembly.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Domain
import Foundation

final class SettingsAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var useCaseAssembly: UseCaseAssembly = self.context.assembly()
    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    // MARK: - Internal Methods

    func assembleModule(
        coordinator: SettingsCoordinator
    ) -> SettingsViewController {
        return define(scope: .prototype, init: SettingsViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

// MARK: Private Methods

private extension SettingsAssembly {
    func assemblePresenter(view: SettingsView, coordinator: SettingsCoordinator) -> SettingsPresenter {
        return define(
            scope: .prototype,
            init: SettingsViewPresenter(
                view: view,
                coordinator: coordinator
            )
        )
    }
}
