//
//  StatisticsDataViewModel.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 05.10.2024.
//
import SwiftUI

class StatisticsDataViewModel: ObservableObject {
    private enum Constants {
        static let oneWeek = 7
    }

    @Published var moodsScores: [MoodNoteViewItem] = []
    @Published var factText: String = ""
    @Published var selectedSegment: String = "" { didSet { updateVisibleMoodScores() } }
    @Published var segments: [String] = []
    @Published var moodDistribution: [MoodDistributionViewItem] = MoodDistributionViewItem.empty
    @Published var date: String = ""
    
    private var allMoodScores: [MoodNoteViewItem] = []
    
    func setupData(
        factText: String,
        moodsScores: [MoodNoteViewItem],
        segments: [String],
        date: String
    ) {
        self.factText = factText
        self.moodsScores = moodsScores
        self.segments = segments
        self.date = date
        
        allMoodScores = moodsScores
        moodDistribution = MoodDistributionViewItem.empty
        moodsScores.forEach {
            moodDistribution[$0.score - 1].totalFrequent += 1
            moodDistribution[$0.score - 1].score = $0.score
        }
        
        self.selectedSegment = segments[.zero]
    }
    
    //TODO: Вынести логику в презентер в MT-11
    private func updateVisibleMoodScores() {
        if selectedSegment == segments[1] {
            moodsScores = allMoodScores.suffix(Constants.oneWeek)
                .enumerated()
                .map { MoodNoteViewItem(position: $0.offset, score: $0.element.score) }
        } else {
            moodsScores = allMoodScores
                .map { MoodNoteViewItem(position: $0.position, score: $0.score) }
        }
        
        moodDistribution = MoodDistributionViewItem.empty
        moodsScores.forEach {
            moodDistribution[$0.score - 1].totalFrequent += 1
            moodDistribution[$0.score - 1].score = $0.score
        }
    }
}
