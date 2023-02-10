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
    @Published var index = 0
    @Published var isSuccess = false
    
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
        titleValue = ""
        bodyValue = ""
        index = 0
        isSuccess = false
    }
    
    func addJournal() {
        var journal = JournalModel()
        journal.title = titleValue
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
            }, receiveValue: { [weak self] isSuccess in
                guard let self = self else { return }
                self.isSuccess = isSuccess
            })
            .store(in: &cancellables)
    }
}
