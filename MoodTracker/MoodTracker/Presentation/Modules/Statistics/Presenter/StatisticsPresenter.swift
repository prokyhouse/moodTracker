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
import Storage

protocol StatisticsPresenter: AnyObject {
    func onViewDidLoad()
    func onViewVillAppear()
}

final class StatisticsViewPresenter {
    // MARK: - Private Properties

    private unowned let view: StatisticsView
    private let coordinator: StatisticsCoordinator
    private let storage: CoreDataService
    
    private var moodDistribution: [MoodDistributionViewItem] = []
    private var moodsScores: [MoodNoteViewItem] = []
    private var dateRange: String = ""
    private var lastSelectedSegment = ""
    
    private var allMoodNotes: [MoodNote] = []

    // MARK: - Initialization

    init(
        view: StatisticsView,
        coordinator: StatisticsCoordinator,
        storage: CoreDataService
    ) {
        self.view = view
        self.coordinator = coordinator
        self.storage = storage
    }
}

// MARK: - StatisticsPresenter

extension StatisticsViewPresenter: StatisticsPresenter {
    func onViewDidLoad() {
        view.setTitle(Constants.L10n.title)
    }
    
    func onViewVillAppear() {
        allMoodNotes = storage.fetchLastMonthNotes()
        
        updateVisibleMoodScores(selectedSegment: lastSelectedSegment)
        setUpStatistics()
    }
}

// MARK: - Private Methods

private extension StatisticsViewPresenter {
    enum Constants {
        enum L10n {
            static let title = "Статистика"
            static let weekSegment = "Неделя"
            static let monthSegment = "Месяц"
            static let factText = "По статистике, в этом месяце было больше хороших дней, чем плохих. Так держать!"
        }
        
        static let oneWeek = 7
    }
    
    private func updateVisibleMoodScores(selectedSegment: String) {
        if selectedSegment == Constants.L10n.weekSegment {
            let week = allMoodNotes.suffix(Constants.oneWeek)
            setupDateRange(notes: Array(week))
            moodsScores = week
                .enumerated()
                .map { MoodNoteViewItem(position: $0.offset, score: $0.element.moodLevel) }
        } else {
            setupDateRange(notes: allMoodNotes)
            moodsScores = allMoodNotes
                .enumerated()
                .map { MoodNoteViewItem(position: $0.offset, score: $0.element.moodLevel) }
        }
        
        moodDistribution = MoodDistributionViewItem.empty
        moodsScores.forEach {
            moodDistribution[$0.score - 1].totalFrequent += 1
            moodDistribution[$0.score - 1].score = $0.score
        }
    }
    
    
    private func setUpStatistics() {
        view.setStatisticView(
            factText: Constants.L10n.factText,
            moodsScores: moodsScores,
            segments: [Constants.L10n.monthSegment, Constants.L10n.weekSegment],
            date: dateRange,
            moodDistribution: moodDistribution,
            onSelectedSegmentChanged: { [weak self] in
                self?.lastSelectedSegment = $0
                self?.updateVisibleMoodScores(selectedSegment: $0)
                self?.setUpStatistics()
            }
        )
    }
    
    private func setupDateRange(notes: [MoodNote]) {
        if let fromDay = notes.first?.createDate,
           let toDay = notes.last?.createDate {
            dateRange = getStringFrom(date: fromDay) + " - " + getStringFrom(date: toDay)
        }
    }
    
    private func getStringFrom(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)
        formatter.dateFormat = "d"
        let day = formatter.string(from: date)
        return String(describing: day) + " " + String(describing: month)
    }
}
