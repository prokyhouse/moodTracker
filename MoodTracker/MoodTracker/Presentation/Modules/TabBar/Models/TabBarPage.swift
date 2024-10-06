//
//  TabBarPage.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Design
import UIKit

public enum TabBarPage: Int, CaseIterable {
    case main = 0
    case statistics = 1

    public func getTitle() -> String {
        return title
    }
    
    public func getIcon(for state: TabBarPageState) -> UIImage {
        switch state {
        case .selected:
            return selectedIcon

        case .unselected, .disabled:
            return unselectedIcon
        }
    }
}

// MARK: - Properties

private extension TabBarPage {
    var title: String {
        switch self {
        case .main:
            return "Главная"
        case .statistics:
            return "Статистика"
        }
    }
    
    var unselectedIcon: UIImage {
        switch self {
        case .main:
            return AppResources.images.home.get()

        case .statistics:
            return AppResources.images.chart.get()
        }
    }
    
    var selectedIcon: UIImage {
        switch self {
        case .main:
            return AppResources.images.homeFill.get()

        case .statistics:
            return AppResources.images.chartFill.get()
        }
    }
}
