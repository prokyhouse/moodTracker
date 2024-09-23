//
//  RoundedTabItem.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import UIKit

public struct RoundedTabItem {
    let title: String
    let icon: UIImage
    let state: TabBarPageState
    let action: ((TabBarPage) -> Void)?
    let index: Int

    public init(
        title: String,
        icon: UIImage,
        state: TabBarPageState,
        action: ((TabBarPage) -> Void)?,
        index: Int
    ) {
        self.title = title
        self.state = state
        self.icon = icon
        self.action = action
        self.index = index
    }
}
