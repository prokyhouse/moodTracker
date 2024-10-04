//
//  StatisticsCoordinator.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 01.10.2024.
//

import Common
import Design
import Domain
import UIKit

final class StatisticsCoordinator: BaseNavigationCoordinator {
    // MARK: - Lifecycle

    override func start() {
        showStatistics()
    }

    override func close(animated: Bool) {
        delegate?.coordinatorDidClose(self)
    }

    // MARK: - Screens

    func showStatistics() {
        let viewController = StatisticsAssembly.instance().assembleModule(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
