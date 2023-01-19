//
//  HomePresenter.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI
import Combine

class HomePresenter: ObservableObject {
    @Published var journals: [JournalModel] = []
    @Published var errorMessage: String = ""
    @Published var viewState: ViewState = .loading
    
    private let homeUseCase: HomeUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
        getJournalList()
    }
    
    deinit {
        self.cancellables.removeAll()
    }
}

extension HomePresenter {
    func getJournalList() {
        viewState = .loading
        homeUseCase.getJournalList()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.viewState = .fail
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] journals in
                guard let self = self else { return }
                withAnimation(.spring()) {
                    self.journals = journals
                    
                    if journals.isEmpty {
                        self.viewState = .empty
                    } else {
                        self.viewState = .loaded
                    }
                }
            })
            .store(in: &cancellables)
    }
}
