//
//  SettingsCoordinator.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Design
import Domain
import UIKit

final class SettingsCoordinator: BaseNavigationCoordinator {
    // MARK: - Lifecycle

    override func start() {
        showSettings()
    }

    override func close(animated: Bool) {
        delegate?.coordinatorDidClose(self)
    }

    // MARK: - Screens

    func showSettings() {
        let viewController = SettingsAssembly.instance().assembleModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
