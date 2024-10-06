//
//  StatisticsDataView.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 04.10.2024.
//

import Charts
import Design
import SwiftUI

struct MoodNoteViewItem: Identifiable, Equatable {
    let id = UUID()
    
    let position: Int
    let score: Int
}

struct MoodDistributionViewItem: Identifiable, Equatable {
    let id = UUID()
    
    let associatedName: String
    var totalFrequent: Int = 0
    var score: Int = 0
    
    static var empty: [Self] {
        [
            MoodDistributionViewItem(associatedName: "Очень приятный"),
            MoodDistributionViewItem(associatedName: "Приятный"),
            MoodDistributionViewItem(associatedName: "Нейтральный"),
            MoodDistributionViewItem(associatedName: "Неприятный"),
            MoodDistributionViewItem(associatedName: "Грустный")
        ].reversed()
    }
}

struct StatisticsDataView: View {
    private enum Constants {
        static let chartWidth: CGFloat = 318
        static let chartHeight: CGFloat = 135
        static let horizontalPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 24
        static let imageSide: CGFloat = 48
        static let factCornerRadius: CGFloat = 20
    }
    
    @ObservedObject var statisticsDataViewModel: StatisticsDataViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            Picker("", selection: $statisticsDataViewModel.selectedSegment) {
                ForEach(statisticsDataViewModel.segments, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom, Constants.bottomPadding)
            
            Chart {
                ForEach(statisticsDataViewModel.moodsScores) { mood in
                    BarMark(
                        x: .value("", mood.position),
                        y: .value("", mood.score),
                        width: (
                            statisticsDataViewModel.selectedSegment == statisticsDataViewModel.segments[1]
                            ? .fixed(16.0)
                            : .automatic
                        )
                    )
                    .foregroundStyle(getMoodLevelAssociatedColor(mood.score))
                    .cornerRadius(4)
                }
            }
            .frame(width: Constants.chartWidth, height: Constants.chartHeight)
            .chartXScale(domain: .zero ... max(statisticsDataViewModel.moodsScores.count - 1, 1))
            .chartYAxis(.hidden)
            .chartXAxis(.hidden)
            .padding(.bottom, Constants.bottomPadding)
            
            HStack(alignment: .bottom, spacing: 16) {
                Text(statisticsDataViewModel.factText)
                    .font(Font(AppResources.fonts.styles.subtitle))
                    .foregroundStyle(.black)
                    .padding(16)
                    .overlay {
                        UnevenRoundedRectangle(
                            topLeadingRadius: Constants.factCornerRadius,
                            bottomLeadingRadius: Constants.factCornerRadius,
                            bottomTrailingRadius: .zero,
                            topTrailingRadius: Constants.factCornerRadius
                        )
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                    }
                
                Image(uiImage: AppResources.images.search.get())
                    .frame(width: Constants.imageSide, height: Constants.imageSide)
            }
            
            HStack {
                Spacer()
                Text(statisticsDataViewModel.date)
                    .foregroundStyle(Color(uiColor: AppResources.colors.gray))
                    .font(Font(AppResources.fonts.styles.caption))
            }
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            HStack(spacing: .zero) {
                ForEach(statisticsDataViewModel.moodDistribution) {
                    getMoodLevelAssociatedColor($0.score)
                        .frame(
                            width: (UIScreen.main.bounds.width - Constants.horizontalPadding * 2)
                            * (CGFloat($0.totalFrequent) / CGFloat(max(statisticsDataViewModel.moodsScores.count, 1)))
                        )
                }
            }
            .cornerRadius(6)
            .frame(height: 24)
            
            VStack(spacing: 6) {
                ForEach(statisticsDataViewModel.moodDistribution.reversed()) { distribution in
                    HStack {
                        Text(distribution.associatedName)
                            .foregroundStyle(Color(uiColor: AppResources.colors.gray))
                            .font(Font(AppResources.fonts.styles.caption))
                        Spacer()
                        Text(
                            String(Int((
                                CGFloat(distribution.totalFrequent) / CGFloat(max(statisticsDataViewModel.moodsScores.count, 1))
                            ) * 100)) + "%"
                        )
                        .foregroundStyle(Color(uiColor: AppResources.colors.elements))
                        .font(Font(AppResources.fonts.styles.caption))
                        Circle()
                            .fill(getMoodLevelAssociatedColor(distribution.score))
                            .frame(width: 7, height: 7)
                            .padding(.leading, 4)
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .animation(.smooth, value: statisticsDataViewModel.moodsScores)
    }
    
    private func getMoodLevelAssociatedColor(_ index: Int) -> Color {
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
