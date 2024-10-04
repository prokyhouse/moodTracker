//
//  ChartView.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 04.10.2024.
//

import Charts
import Design
import SwiftUI

struct MoodNote: Identifiable, Equatable {
    let id = UUID()
    
    let position: Int
    let score: Int
}

class ChartViewModel: ObservableObject {
    @Published var moodsScores: [MoodNote] = []
}

struct ChartView: View {
    private enum Constants {
        static let chartWidth: CGFloat = 318
        static let chartHeight: CGFloat = 135
    }
    
    @ObservedObject var chartViewModel: ChartViewModel
    
    var body: some View {
        Chart {
            ForEach(chartViewModel.moodsScores) { mood in
                BarMark(
                    x: .value("", mood.position),
                    y: .value("", mood.score),
                    width: (
                        chartViewModel.moodsScores.count == 7
                        ? .fixed(Constants.chartWidth / CGFloat(chartViewModel.moodsScores.count + 1))
                        : .automatic
                    )
                )
                .foregroundStyle(getColor(mood.score))
                .cornerRadius(4)
            }
        }
        .frame(width: Constants.chartWidth, height: Constants.chartHeight)
        .padding(.horizontal, 16)
        .animation(.bouncy, value: chartViewModel.moodsScores)
        .chartXScale(domain: .zero ... chartViewModel.moodsScores.count - 1)
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
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
    ChartView(chartViewModel: ChartViewModel())
}
