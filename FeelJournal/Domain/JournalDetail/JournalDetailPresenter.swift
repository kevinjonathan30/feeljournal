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
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(journalDetailUseCase: JournalDetailUseCase) {
        self.journalDetailUseCase = journalDetailUseCase
    }
    
    deinit {
        self.cancellables.removeAll()
    }
}

extension JournalDetailPresenter {
    func editJournal(journal: JournalModel) {
        guard journal.body != bodyValue else { return }
        
        let newJournal = JournalModel(
            id: journal.id,
            title: journal.title,
            createdAt: journal.createdAt,
            body: bodyValue,
            feelingIndex: NaturalLanguageProcessor.processSentimentAnalysis(input: bodyValue),
            audioUrl: journal.audioUrl
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
                    EventPublisher.shared.journalSubject.send(.refreshAnalytics)
                }
            })
            .store(in: &cancellables)
    }
    
    func deleteJournal(withId id: String) {
        journalDetailUseCase.deleteJournal(withId: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] isSuccess in
                guard self != nil else { return }
                if isSuccess {
                    EventPublisher.shared.journalSubject.send(.refreshJournalList)
                    EventPublisher.shared.journalSubject.send(.refreshAnalytics)
                    NavigationController.pop()
                }
            })
            .store(in: &cancellables)
    }
}
