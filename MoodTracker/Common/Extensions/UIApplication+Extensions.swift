//
//  UIApplication+Extensions.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 23.09.2024.
//

import Foundation
import UIKit

public extension UIApplication {
    var hasBottomSafeArea: Bool {
        (mainWindow?.safeAreaInsets.bottom ?? 0) > 0
    }
}

public extension UIApplication {
    var mainWindow: UIWindow? {
        connectedScenes
            .compactMap { $0.isActive ? ($0 as? UIWindowScene)?.windows : nil }
            .flatMap { $0 }
            .first { $0.isKeyWindow }
    }
}

private extension UIScene {
    var isActive: Bool {
        switch activationState {
        case .foregroundActive, .foregroundInactive:
            return true

        default:
            return false
        }
    }
}
