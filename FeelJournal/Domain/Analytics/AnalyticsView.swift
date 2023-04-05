//
//  AnalyticsView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @StateObject var presenter: AnalyticsPresenter
    
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
                Section(header: Text("My Feeling Stats")) {
                    chartView()
                        .padding(.vertical)
                }
                
                Section(header: Text("Average Feeling")) {
                    VStack(alignment: .leading) {
                        Text(presenter.averageFeeling)
                            .font(.headline)
                            .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Analytics")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    NavigationController.push(.settings)
                } label: {
                    Image(systemName: "gearshape.fill")
                }
            }
        }
    }
}

// MARK: ViewBuilder

private extension AnalyticsView {
    @ViewBuilder
    func chartView() -> some View {
        VStack {
            switch presenter.viewState {
            case .loading:
                chartLoadingView()
            case .fail, .empty:
                chartFailView()
            case .loaded:
                chartLoadedView()
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.25)
    }
    
    @ViewBuilder
    func chartLoadingView() -> some View {
        ProgressView()
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    func chartFailView() -> some View {
        Text(self.presenter.message)
            .font(.headline)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
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

// MARK: Preview

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(presenter: Provider.provideAnalyticsPresenter())
    }
}
