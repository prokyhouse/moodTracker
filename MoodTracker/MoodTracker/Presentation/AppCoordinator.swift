//
//  AppCoordinator.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//


import Common
import Design
import Domain
import UIKit

public final class AppCoordinator: BaseCoordinator<UIWindow> {
    // MARK: - Public Properties

    public var window: UIWindow {
        root as UIWindow
    }

    // MARK: - Lifecycle

    public init(window: UIWindow) {
        super.init(root: window)
    }

    // MARK: - Public Methods

    override public func start() {
        AppResources.appearance.updateAppearance()

        goToGeneralFlow()
    }

    override public func add(child coordinator: any Coordinator) {
        super.add(child: coordinator)
        switch coordinator.root {
        case let viewController as UIViewController:
            window.rootViewController = viewController

            if window.isKeyWindow == false {
                window.makeKeyAndVisible()
            }

        default:
            break
        }
    }

    override public func coordinatorDidClose(_ coordinator: some Coordinator) {
        super.coordinatorDidClose(coordinator)
    }

    // MARK: - Flows

//    public func goToOnboardingFlow() {
//        let navigationController = UINavigationController()
//        let coordinator = OnboardingCoordinator(navigationController: navigationController)
//        add(child: coordinator)
//        coordinator.start()
//    }

    public func goToGeneralFlow() {
        let tabBarController = TabBarAssembly.instance().assembleModule()
        let coordinator = TabBarCoordinator(tabBarController: tabBarController)
        tabBarController.presenter?.setCoordinator(coordinator)
        add(child: coordinator)
        coordinator.start()
    }
}
