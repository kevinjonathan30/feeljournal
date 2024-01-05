//
//  AnalyticsPresenter.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI
import Combine

class AnalyticsPresenter: ObservableObject {
    @Published var journals: [JournalModel] = []
    @Published var selectedFilter = 0
    @Published var viewState: ViewState = .loading
    @Published var message: String = ""
    var averageFeeling: Double {
        guard !self.journals.isEmpty else { return -3 }
        
        let feelingSum = self.journals.map({ $0.feelingIndex ?? 0.0 }).reduce(0, +)
        return feelingSum / Double(self.journals.count)
    }
    
    private let analyticsUseCase: AnalyticsUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(analyticsUseCase: AnalyticsUseCase) {
        self.analyticsUseCase = analyticsUseCase
        getJournalList()
        initJournalObserver()
    }
    
    deinit {
        self.cancellables.removeAll()
    }
}

extension AnalyticsPresenter {
    func initJournalObserver() {
        EventPublisher.shared.journalPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .refreshJournalList:
                    self.getJournalList()
                }
            }
            .store(in: &cancellables)
    }
    
    func getJournalList() {
        analyticsUseCase.getJournalList()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.viewState = .fail
                    self.message = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] journals in
                guard let self = self else { return }
                withAnimation {
                    switch self.selectedFilter {
                    case 0:
                        self.journals = journals.filter({ $0.createdAt ?? Date() > Date(timeIntervalSinceNow: -7 * 60 * 60 * 24) && $0.feelingIndex ?? 0 >= -1 })
                    case 1:
                        self.journals = journals.filter({ $0.createdAt ?? Date() > Date(timeIntervalSinceNow: -30 * 60 * 60 * 24) && $0.feelingIndex ?? 0 >= -1 })
                    default:
                        break
                    }
                    
                    if self.journals.isEmpty {
                        self.viewState = .empty
                        self.message = "No Data"
                    } else {
                        self.viewState = .loaded
                    }
                }
            })
            .store(in: &cancellables)
    }
}
