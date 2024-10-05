//
//  StatisticsDataView.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 04.10.2024.
//

import Charts
import Design
import SwiftUI

private enum Constants {
    enum L10n {
        static let monthPage: String = "Месяц"
        static let weekPage: String = "Неделя"
    }
    
    static let chartWidth: CGFloat = 318
    static let chartHeight: CGFloat = 135
    static let oneWeek = 7
}

struct MoodNote: Identifiable, Equatable {
    let id = UUID()
    
    let position: Int
    let score: Int
}

class StatisticsDataViewModel: ObservableObject {
    @Published var moodsScores: [MoodNote] = []
    @Published var factText: String = ""
    @Published var selectedSegment = Constants.L10n.monthPage { didSet { updateVisibleMoodScores() } }
    
    private var allMoodScores: [MoodNote] = []
    
    func setupData(factText: String, moodsScores: [MoodNote]) {
        self.factText = factText
        self.moodsScores = moodsScores
        
        allMoodScores = moodsScores
    }
    
    private func updateVisibleMoodScores() {
        if selectedSegment == Constants.L10n.weekPage {
            moodsScores = allMoodScores.suffix(Constants.oneWeek)
                .enumerated()
                .map { MoodNote(position: $0.offset, score: $0.element.score) }
        } else {
            moodsScores = allMoodScores
                .map { MoodNote(position: $0.position, score: $0.score) }
        }
    }
}

struct StatisticsDataView: View {
    
    @ObservedObject var statisticsDataViewModel: StatisticsDataViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            Picker("", selection: $statisticsDataViewModel.selectedSegment) {
                ForEach([Constants.L10n.monthPage, Constants.L10n.weekPage], id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            
            Chart {
                ForEach(statisticsDataViewModel.moodsScores) { mood in
                    BarMark(
                        x: .value("", mood.position),
                        y: .value("", mood.score),
                        width: (
                            statisticsDataViewModel.moodsScores.count == Constants.oneWeek
                            ? .fixed(16.0)
                            : .automatic
                        )
                    )
                    .foregroundStyle(getColor(mood.score))
                    .cornerRadius(4)
                }
            }
            .frame(width: Constants.chartWidth, height: Constants.chartHeight)
            .animation(.smooth, value: statisticsDataViewModel.moodsScores)
            .chartXScale(domain: .zero ... max(statisticsDataViewModel.moodsScores.count - 1, 1))
            .chartYAxis(.hidden)
            .chartXAxis(.hidden)
            .padding(.bottom, 24)
            
            HStack(alignment: .bottom, spacing: 16) {
                Text(statisticsDataViewModel.factText)
                    .font(Font(AppResources.fonts.styles.subtitle))
                    .foregroundStyle(.black)
                    .padding(16)
                    .overlay {
                        UnevenRoundedRectangle(
                            topLeadingRadius: 20,
                            bottomLeadingRadius: 20,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 20
                        )
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                    }
                
                Image(uiImage: AppResources.images.search.get())
                    .frame(width: 48, height: 48)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func getColor(_ index: Int) -> Color {
        switch index {
        case 5:
            return Color(uiColor: AppResources.colors.red)
            
        case 4:
            return Color(uiColor: AppResources.colors.orange)
            
        case 3:
            return Color(uiColor: AppResources.colors.indigo)
            
        case 2:
            return Color(uiColor: AppResources.colors.green)
            
        case 1:
            return Color(uiColor: AppResources.colors.blue)
            
        default:
            return Color(uiColor: AppResources.colors.background)
        }
    }
}

#Preview {
    StatisticsDataView(statisticsDataViewModel: StatisticsDataViewModel())
}
