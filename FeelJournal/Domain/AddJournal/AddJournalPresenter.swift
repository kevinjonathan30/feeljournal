//
//  AddJournalPresenter.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI
import Combine

class AddJournalPresenter: ObservableObject {
    @Published var bodyValue = ""
    
    private let addJournalUseCase: AddJournalUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(addJournalUseCase: AddJournalUseCase) {
        self.addJournalUseCase = addJournalUseCase
    }
    
    deinit {
        self.cancellables.removeAll()
    }
}

extension AddJournalPresenter {
    func resetState() {
        bodyValue = ""
    }
    
    func addJournal() {
        var journal = JournalModel()
        journal.title = Date().convertToFullDateInString()
        journal.body = bodyValue
        journal.createdAt = Date()
        journal.feelingIndex = NaturalLanguageProcessor.processSentimentAnalysis(input: bodyValue)
        
        addJournalUseCase.addJournal(journal: journal)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    break
                case .finished:
                    break
                }
            }, receiveValue: { isSuccess in
                if isSuccess {
                    EventPublisher.shared.journalSubject.send(.refreshJournalList)
                    EventPublisher.shared.journalSubject.send(.refreshAnalytics)
                    NavigationController.pop()
                }
            })
            .store(in: &cancellables)
    }
}
