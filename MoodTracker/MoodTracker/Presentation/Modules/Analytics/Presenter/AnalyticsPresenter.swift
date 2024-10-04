//
//  StatisticsPresenter.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 01.10.2024.
//


import Common
import Design
import Domain
import UIKit

protocol StatisticsPresenter: AnyObject {
   
}

final class StatisticsViewPresenter {
    // MARK: - Private Properties

    private unowned let view: StatisticsView
    private let coordinator: StatisticsCoordinator

    // MARK: - Initialization

    init(
        view: StatisticsView,
        coordinator: StatisticsCoordinator
    ) {
        self.view = view
        self.coordinator = coordinator
    }
}

// MARK: - StatisticsPresenter

extension StatisticsViewPresenter: StatisticsPresenter {
  
}

// MARK: - Private Methods

private extension StatisticsViewPresenter { }
