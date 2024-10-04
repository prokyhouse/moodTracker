//
//  AppDelegate.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Domain
import Storage
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate, CoreDataServiceDelegate {
    
    // MARK: - UIApplicationDelegate
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // MARK: Database
        let coreDataService = CoreDataService.shared
        coreDataService.delegate = self
        coreDataService.setup { result in
            switch result {
            case .failed:
                // Тут БД разрушена, лучше бы не ходить дальше.
                break

            case .success:
                // БД настроена без проблем.
                break

            @unknown default:
                assertionFailure()
            }
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
}
