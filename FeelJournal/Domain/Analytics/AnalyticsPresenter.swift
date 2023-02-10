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
    
    private let analyticsUseCase: AnalyticsUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(analyticsUseCase: AnalyticsUseCase) {
        self.analyticsUseCase = analyticsUseCase
    }
    
    deinit {
        self.cancellables.removeAll()
    }
}

extension AnalyticsPresenter {
    func getJournalList() {
        analyticsUseCase.getJournalList()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] journals in
                guard let self = self else { return }
                withAnimation(.spring()) {
                    self.journals = journals
                }
            })
            .store(in: &cancellables)
    }
}
