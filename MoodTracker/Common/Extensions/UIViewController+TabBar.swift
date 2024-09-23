//
//  UIViewController+TabBar.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 23.09.2024.
//


import Foundation
import UIKit

public extension UIViewController {
    func tabBarBottomInset(ignoreSafeArea: Bool = false) -> CGFloat {
        let tabbarHeight = tabBarController?.tabBar.bounds.height ?? 0
        let bottomSafeAreaInset = ignoreSafeArea ? 0 : view.safeAreaInsets.bottom
        return tabbarHeight - bottomSafeAreaInset
    }
}
