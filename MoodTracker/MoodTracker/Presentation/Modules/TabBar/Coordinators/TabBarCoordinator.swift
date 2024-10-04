//
//  TabBarCoordinator.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Design
import Domain
import UIKit

public final class TabBarCoordinator: BaseTabCoordinator {
    // MARK: Parameters

    public var currentTabbarController: TabBarController? {
        return tabBarController as? TabBarController
    }

    // MARK: - Public methods

    override public func start() {
        initializeTabBar()
    }

    override public func coordinatorDidClose(_ coordinator: some Coordinator) {
        super.coordinatorDidClose(coordinator)

        delegate?.coordinatorDidClose(self)
    }

    // MARK: - Screens

    public func initializeTabBar() {
        let tabControllers: [UINavigationController] = makeAndStartTabs()
        setupTabBar(with: tabControllers)
    }

    public func updateTabBar() {
        guard
            let tabBarController = currentTabbarController
        else {
            debugPrint(
                """
                ⚠️ Не удалось обновить TabBar.\n
                \(String(describing: currentTabbarController)) needs to be initialized before update.
                """
            )
            return
        }

        tabBarController.updateTabBar()
    }
}

// MARK: - Private Methods

private extension TabBarCoordinator {
    func setupTabBar(with tabControllers: [UIViewController]) {
        currentTabbarController?.setViewControllers(tabControllers, animated: false)

        if let tabBar = currentTabbarController {
            tabBar.selectedIndex = TabBarPage.main.rawValue
            let tabs = tabBar.makeTabs()
            tabBar.setItems(tabs)
        }
    }

    func makeAndStartTabs() -> [UINavigationController] {
        var tabControllers: [UINavigationController] = []

        for tab in TabBarPage.allCases {
            let controller: UINavigationController

            switch tab {
            case .main:
                controller = makeAndStartMainTabController()
            }

            controller.setNavigationBarHidden(true, animated: false)
            tabControllers.append(controller)
        }

        return tabControllers
    }

    func makeAndStartMainTabController() -> UINavigationController {
        let navigationController = UINavigationController()
        let coordinator = MainCoordinator(navigationController: navigationController)
        add(child: coordinator)
        coordinator.start()
        return navigationController
    }
}
