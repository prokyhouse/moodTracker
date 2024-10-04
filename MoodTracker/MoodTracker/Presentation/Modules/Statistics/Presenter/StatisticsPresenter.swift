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
    func onViewDidLoad()
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
    func onViewDidLoad() {
        view.setTitle(Constants.L10n.title)
        view.setNote(Constants.L10n.note)
    }
}

// MARK: - Private Methods

private extension StatisticsViewPresenter {
    enum Constants {
        enum L10n {
            static let title: String = "Статистика"
            static let note: String = "По статистике, в этом месяце было больше хороших дней, чем плохих. Так держать!"
        }
    }
}
