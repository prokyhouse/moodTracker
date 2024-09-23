//
//  BaseTabCoordinator.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 23.09.2024.
//


import UIKit

open class BaseTabCoordinator: BaseCoordinator<UITabBarController> {
    // MARK: - Public Properties

    public var tabBarController: UITabBarController {
        root as UITabBarController
    }

    // MARK: - Lifecycle

    public init(tabBarController: UITabBarController) {
        super.init(root: tabBarController)
    }
}
