//
//  StatisticsUseCase.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 06.10.2024.
//

import Storage

final public class StatisticsUseCase {
    private enum Constants {
        static let oneWeek = 7
    }
    
    private let storageService: CoreDataService
    private var allMoodNotes: [MoodNote] = []
    
    public init(storageService: CoreDataService) {
        self.storageService = storageService
    }
    
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
            return getStringFrom(date: fromDay) + " - " + getStringFrom(date: toDay)
        }
        
        return ""
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
