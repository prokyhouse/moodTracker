//
//  TabBarPresenter.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Domain
import Foundation

protocol TabBarPresenter: AnyObject {
    func enter()
    func setCoordinator(_ value: TabBarCoordinator)
}

final class TabBarViewPresenter {
    // MARK: - Private Properties

    private var coordinator: TabBarCoordinator?
    private unowned let view: TabBarView

    // MARK: - Initialization

    init(view: TabBarView) {
        self.view = view
    }
}

// MARK: - MaterialsPresenter

extension TabBarViewPresenter: TabBarPresenter {
    func enter() { }

    func setCoordinator(_ value: TabBarCoordinator) {
        self.coordinator = value
    }
}
