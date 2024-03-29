//
//  JournalDetailPresenter.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 24/03/23.
//

import SwiftUI
import Combine

class JournalDetailPresenter: ObservableObject {
    @Published var showConfirmationDialog = false
    @Published var bodyValue = ""
    
    private let journalDetailUseCase: JournalDetailUseCase
    let journal: JournalModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(journalDetailUseCase: JournalDetailUseCase, journal: JournalModel) {
        self.journalDetailUseCase = journalDetailUseCase
        self.journal = journal
        self.bodyValue = journal.body ?? ""
    }
    
    deinit {
        self.cancellables.removeAll()
    }
}

extension JournalDetailPresenter {
    func editJournal() {
        guard journal.body != bodyValue else { return }
        
        let newJournal = JournalModel(
            id: journal.id,
            title: journal.title,
            createdAt: journal.createdAt,
            updatedAt: Date(),
            body: bodyValue,
            feelingIndex: NaturalLanguageProcessor.processSentimentAnalysis(input: bodyValue)
        )
        
        journalDetailUseCase.editJournal(journal: newJournal)
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
                }
            })
            .store(in: &cancellables)
    }
    
    func deleteJournal() {
        journalDetailUseCase.deleteJournal(withId: journal.id.uuidString)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] isSuccess in
                guard self != nil else { return }
                if isSuccess {
                    EventPublisher.shared.journalSubject.send(.refreshJournalList)
                    NavigationController.pop()
                }
            })
            .store(in: &cancellables)
    }
}
