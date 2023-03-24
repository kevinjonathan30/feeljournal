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
