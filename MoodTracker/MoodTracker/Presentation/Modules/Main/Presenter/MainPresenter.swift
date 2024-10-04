//
//  MainPresenter.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//


import Common
import Design
import Domain
import UIKit

protocol MainPresenter: AnyObject {
    /// Обработка входа на экран.
    func onViewDidLoad()

    /// Триггер загрузки данных
    func onViewDidAppear()

    /// События показа экрана
    func onViewWillAppear()

    /// Обработка нажатия на ячейку настроения
    func onMoodCellTap(withId id: UUID)
}

final class MainViewPresenter {
    // MARK: - Private Properties

    private unowned let view: MainView
    private let coordinator: MainCoordinator

    // MARK: - Initialization

    init(
        view: MainView,
        coordinator: MainCoordinator
    ) {
        self.view = view
        self.coordinator = coordinator
    }
}

// MARK: - MainPresenter

extension MainViewPresenter: MainPresenter {
    func onViewDidLoad() {
        view.setTitle(Constants.L10n.title)

        displayMocks()
    }

    func onViewWillAppear() { }

    func onViewDidAppear() { }

    func onMoodCellTap(withId id: UUID) {
        //TODO: Добавить переход на детальный экран
    }

    //TODO: Добавить бизнес-логику
    func displayMocks() {
        view.displayMoodReports(
            [
                .init(
                    id: UUID(),
                    title: "Грустный день",
                    caption: "Сегодня, 26 сентября",
                    moodImage: AppResources.images.calm.get(),
                    color: AppResources.colors.blue
                ),
                .init(
                    id: UUID(),
                    title: "Приятный день",
                    caption: "Вчера, 25 сентября",
                    moodImage: AppResources.images.calm.get(),
                    color: AppResources.colors.orange
                ),
                .init(
                    id: UUID(),
                    title: "Нейтральный день",
                    caption: "Позавчера, 24 сентября",
                    moodImage: AppResources.images.calm.get(),
                    color: AppResources.colors.green
                ),
            ]
        )

        view.displayFact(.init(title: "А вы знали, что...", description: "Кирилл пилит это приложение в четверг"))
    }
}

// MARK: - Private Methods

private extension MainViewPresenter {
    enum Constants {
        enum L10n {
            static let title: String = "Как твоё настроение?"
        }
    }
}
