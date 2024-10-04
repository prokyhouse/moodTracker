//
//  MainCoordinator.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Design
import Domain
import UIKit

final class MainCoordinator: BaseNavigationCoordinator {
    // MARK: - Lifecycle

    override func start() {
        showMain()
    }

    override func close(animated: Bool) {
        delegate?.coordinatorDidClose(self)
    }

    // MARK: - Screens

    func showMain() {
        let viewController = MainAssembly.instance().assembleModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
