//
//  AddJournalInteractor.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import Foundation
import Combine

protocol AddJournalUseCase {}

class AddJournalInteractor: AddJournalUseCase {
    private let repository: FeelJournalRepositoryProtocol
    
    init(repository: FeelJournalRepositoryProtocol) {
        self.repository = repository
    }
}
