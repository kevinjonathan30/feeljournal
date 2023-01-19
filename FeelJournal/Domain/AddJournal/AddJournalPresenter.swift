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
    }
}
