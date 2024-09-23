//
//  TabBarPageState.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Design
import UIKit

public enum TabBarPageState {
    case selected
    case unselected
    case disabled
}

// MARK: - Properties

extension TabBarPageState {
    var color: UIColor {
        switch self {
        case .selected, .unselected:
            return AppResources.colors.main

        case .disabled:
            return AppResources.colors.disabledElements
        }
    }
}
