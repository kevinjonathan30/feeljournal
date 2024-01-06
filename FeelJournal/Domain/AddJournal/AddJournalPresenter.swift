//
//  AddJournalPresenter.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI
import Combine

class AddJournalPresenter: ObservableObject {
    @Published var titleValue = ""
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
    func addJournal() {
        let currentDate: Date = Date()
        
        var journal = JournalModel()
        journal.title = !titleValue.isEmpty ? titleValue : currentDate.convertToFullDateInString()
        journal.body = bodyValue
        journal.createdAt = currentDate
        journal.updatedAt = currentDate
        journal.feelingIndex = NaturalLanguageProcessor.processSentimentAnalysis(input: bodyValue)
        
        addJournalUseCase.addJournal(journal: journal)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { isSuccess in
                guard isSuccess else { return }
                
                EventPublisher.shared.journalSubject.send(.refreshJournalList)
                NavigationController.pop()
            })
            .store(in: &cancellables)
    }
}
