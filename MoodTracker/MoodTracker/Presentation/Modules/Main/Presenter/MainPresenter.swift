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
import Storage

protocol MainPresenter: AnyObject {
    /// Обработка входа на экран.
    func onViewDidLoad()

    /// Триггер загрузки данных
    func onViewDidAppear()

    /// События показа экрана
    func onViewWillAppear()

    /// Обработка нажатия на ячейку настроения
    func onMoodCellTap(withId id: UUID)

    /// Обработка нажатия "Внести запись"
    func onAddButtonTap()

    /// Обработка удаления
    func onDeleteActionTap(moodId: UUID)
}

final class MainViewPresenter {
    // MARK: - Private Properties

    private unowned let view: MainView
    private let coordinator: MainCoordinator
    private let mainUseCase: Domain.MainUseCase
    private let moodFormatter: MoodUIFormatter

    // MARK: - Initialization

    init(
        view: MainView,
        coordinator: MainCoordinator,
        mainUseCase: Domain.MainUseCase,
        moodFormatter: MoodUIFormatter
    ) {
        self.view = view
        self.coordinator = coordinator
        self.mainUseCase = mainUseCase
        self.moodFormatter = moodFormatter
    }
}

// MARK: - MainPresenter

extension MainViewPresenter: MainPresenter {
    func onViewDidLoad() {
        view.setTitle(Constants.L10n.title)
        configureTip()
        view.displayFact(
            .init(
                title: Constants.L10n.Fact.title,
                description: Constants.L10n.Fact.description
            )
        )
    }

    func onViewWillAppear() {
        updateList()
        configureAddButton()
    }

    func onViewDidAppear() { }

    func onMoodCellTap(withId id: UUID) {
        // FUTURE: Открытие карточки детализации
    }

    func onAddButtonTap() {
        coordinator.showAddReport()
    }

    func onDeleteActionTap(moodId: UUID) {
        mainUseCase.requestDeleteMoodReport(id: moodId, completion: { [weak self] in
            guard let self else { return }
            updateList()
            configureAddButton()
        })
    }
}

// MARK: - Private Methods

private extension MainViewPresenter {
    private func mapReports(_ reports: [Storage.MoodNote]) -> [MoodCell.Props] {
        return reports.compactMap {
            guard let moodType = MoodType(rawValue: $0.moodLevel) else { return nil }
            return MoodCell.Props(
                id: $0.id,
                title: moodFormatter.getMoodDescription(for: moodType),
                caption: mapDate($0.createDate),
                moodImage: moodFormatter.getMoodEmoji(for: moodType),
                color: moodFormatter.getMoodColor(for: moodType)
            )
        }
    }

    private func mapDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)
        formatter.dateFormat = "d"
        let day = formatter.string(from: date)
        return String(describing: day) + " " + String(describing: month)
    }


    private func updateList() {
        let moodReports = mainUseCase.requestMoodReports()
        let cellsProps = mapReports(moodReports)
        view.displayMoodReports(cellsProps)
    }

    private func configureAddButton() {
        let moodReports = mainUseCase.requestMoodReports()
        let hasToday = moodReports.first(where: { Calendar.current.isDateInToday($0.createDate) }) != nil

        let title = hasToday ? nil : Constants.L10n.Add.title
        let image = hasToday ? nil : AppResources.images.mindfulness.get()
        view.setAddButton(title: title, image: image)
    }

    private func configureTip() {
        view.setTip(
            title: Constants.L10n.Tip.title,
            description: Constants.L10n.Tip.description,
            emoji: AppResources.images.disappointed.get()
        )
    }
}
    // MARK: - Constants

private extension MainViewPresenter {
    enum Constants {
        enum L10n {
            static let title: String = "Как твоё настроение?"
            enum Fact {
                static let title: String = "А ты знал, что..."
                static let description: String = "Эмоции могут длиться от доли секунды \n до нескольких минут. "
            }
            enum Add {
                static let title: String = "Внести запись"
            }
            enum Tip {
                static let title: String = "Здесь нет записей"
                static let description: String = "Отслеживание настроения помогает отрефлексировать, что вы чувствовали в тот или иной момент, и собрать историю изменений."
            }
        }
    }
}
