//
//  AnalyticsView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @ObservedObject var presenter: AnalyticsPresenter
    
    var body: some View {
        VStack {
            List {
                VStack {
                    HStack {
                        Image(systemName: "chart.xyaxis.line")
                            .foregroundColor(.indigo)
                            .font(.footnote)
                        
                        Text("My Overall Stats")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.indigo)
                        
                        Spacer()
                    }
                    
                    Divider()
                        .padding(.bottom, 4)
                    
                    chartView()
                }
            }
        }
        .navigationTitle("Analytics")
        .onAppear {
            presenter.getJournalList()
        }
    }
}

// MARK: ViewBuilder

private extension AnalyticsView {
    @ViewBuilder
    func chartView() -> some View {
        Chart(self.presenter.journals) {
            LineMark(
                x: .value("Date", $0.createdAt ?? Date()),
                y: .value("Value", $0.feelingIndex ?? 0)
            )
            PointMark(
                x: .value("Date", $0.createdAt ?? Date()),
                y: .value("Value", $0.feelingIndex ?? 0)
            )
        }
        .chartYAxis {
            AxisMarks(position: .trailing, values: .automatic) { value in
                AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                AxisValueLabel {
                    if let value = value.as(Double.self) {
                        switch value {
                        case -1:
                            Text("Sad")
                        case 1:
                            Text("Happy")
                        case 0:
                            Text("Neutral")
                        default:
                            Color.clear
                        }
                    }
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.25)
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(presenter: AnalyticsPresenter(analyticsUseCase: Provider().provideAnalytics()))
    }
}
