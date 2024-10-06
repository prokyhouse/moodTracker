//
//  StatisticsDataViewModel.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 05.10.2024.
//
import SwiftUI

class StatisticsDataViewModel: ObservableObject {
    
    @Published var moodsScores: [MoodNoteViewItem] = []
    @Published var factText: String = ""
    @Published var selectedSegment: String = "Месяц" {
        didSet { onSelectedSegmentChanged?(selectedSegment) }
    }
    @Published var segments: [String] = []
    @Published var moodDistribution: [MoodDistributionViewItem] = MoodDistributionViewItem.empty
    @Published var date: String = ""
    
    private var onSelectedSegmentChanged: ((String) -> Void)?
    
    func setupData(
        factText: String,
        moodsScores: [MoodNoteViewItem],
        segments: [String],
        date: String,
        moodDistribution: [MoodDistributionViewItem],
        onSelectedSegmentChanged: @escaping (String) -> Void
    ) {
        self.factText = factText
        self.moodsScores = moodsScores
        self.segments = segments
        self.date = date
        self.moodDistribution = moodDistribution
        self.onSelectedSegmentChanged = onSelectedSegmentChanged
    }
}
