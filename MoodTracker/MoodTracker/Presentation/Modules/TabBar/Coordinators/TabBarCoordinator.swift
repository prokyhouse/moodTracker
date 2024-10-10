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

    public var currentTabBarController: TabBarController? {
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
            let tabBarController = currentTabBarController
        else {
            debugPrint(
                """
                ⚠️ Не удалось обновить TabBar.\n
                \(String(describing: currentTabBarController)) needs to be initialized before update.
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
        currentTabBarController?.setViewControllers(tabControllers, animated: false)

        if let tabBar = currentTabBarController {
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

            case .statistics:
                controller = makeAndStartStatisticsTabController()

            case .settings:
                controller = makeAndStartSettingsTabController()
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

    func makeAndStartStatisticsTabController() -> UINavigationController {
        let navigationController = UINavigationController()
        let coordinator = StatisticsCoordinator(navigationController: navigationController)
        add(child: coordinator)
        coordinator.start()
        return navigationController
    }

    func makeAndStartSettingsTabController() -> UINavigationController {
        let navigationController = UINavigationController()
        let coordinator = SettingsCoordinator(navigationController: navigationController)
        add(child: coordinator)
        coordinator.start()
        return navigationController
    }
}
