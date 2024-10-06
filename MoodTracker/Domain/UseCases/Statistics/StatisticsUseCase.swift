//
//  StatisticsUseCase.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 06.10.2024.
//

import Storage

public protocol StatisticsUseCase {
    func getFetchLastMonthNotes() -> [MoodNote]
    func getFetchLastWeekNotes() -> [MoodNote]
    func getDateRange(notes: [MoodNote]) -> String
}

public final class StatisticsUseCaseImpl {

    private let storageService: CoreDataService
    private var allMoodNotes: [MoodNote] = []

    //MARK: - Lifecycle

    public init(storageService: CoreDataService) {
        self.storageService = storageService
    }
    
    //MARK: - Private methods

    private func getStringFrom(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)
        formatter.dateFormat = "d"
        let day = formatter.string(from: date)
        return String(describing: day) + " " + String(describing: month)
    }
}

//MARK: - StatisticsUseCase
extension StatisticsUseCaseImpl: StatisticsUseCase {
    public func getFetchLastMonthNotes() -> [MoodNote] {
        allMoodNotes = storageService.fetchLastMonthNotes()
        return allMoodNotes
    }

    public func getFetchLastWeekNotes() -> [MoodNote] {
        allMoodNotes = storageService.fetchLastMonthNotes()
        return allMoodNotes.suffix(Constants.oneWeek)
    }

    public func getDateRange(notes: [MoodNote]) -> String {
        if let fromDay = notes.first?.createDate,
           let toDay = notes.last?.createDate {
            return getStringFrom(date: fromDay) + Constants.separator + getStringFrom(date: toDay)
        }

        return ""
    }
}

private extension StatisticsUseCaseImpl {
    enum Constants {
        static let oneWeek: Int = 7
        static let separator: String = " - "
    }
}
