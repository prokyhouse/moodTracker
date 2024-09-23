//
//  SceneDelegate.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Internal Properties

    let logger = Common.Logger(category: .analytics)

    var window: UIWindow?
    var coordinator: AppCoordinator?

    // MARK: - Internal Methods

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        coordinator = AppCoordinator(window: window)
        coordinator?.start()
    }
}
