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
    
    func deleteJournal(withId id: String) {
        homeUseCase.deleteJournal(withId: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] isSuccess in
                guard let self = self else { return }
                if isSuccess {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring()) {
                            self.journals.removeAll { $0.id == UUID(uuidString: id) }
                        }
                    }
                }
            })
            .store(in: &cancellables)
    }
}
