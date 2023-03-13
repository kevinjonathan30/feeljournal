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
            Picker("Date Filter", selection: $presenter.selectedFilter) {
                Text("Last 7 days").tag(0)
                Text("Last 30 days").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .onChange(of: presenter.selectedFilter) { _ in
                presenter.getJournalList()
            }
            
            List {
                VStack {
                    HStack {
                        Image(systemName: "chart.xyaxis.line")
                            .foregroundColor(.indigo)
                            .font(.footnote)
                        
                        Text("My Feeling Stats")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.indigo)
                        
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    
                    chartView()
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "memories")
                            .foregroundColor(.indigo)
                            .font(.footnote)
                        
                        Text("Most Common Feeling")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.indigo)
                        
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    
                    Text(presenter.commonFeeling)
                        .font(.headline)
                        .padding(.bottom, 4)
                }
            }
        }
        .navigationTitle("Analytics")
    }
}

// MARK: ViewBuilder

private extension AnalyticsView {
    @ViewBuilder
    func chartView() -> some View {
        VStack {
            switch presenter.viewState {
            case .loading:
                ProgressView()
            case .fail, .empty:
                chartFailView()
            case .loaded:
                chartLoadedView()
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.25)
    }
    
    @ViewBuilder
    func chartFailView() -> some View {
        Text(self.presenter.message)
            .font(.headline)
            .foregroundColor(.gray)
    }
    
    @ViewBuilder
    func chartLoadedView() -> some View {
        Chart(presenter.journals) {
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
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(presenter: AnalyticsPresenter(analyticsUseCase: Provider().provideAnalytics()))
    }
}
