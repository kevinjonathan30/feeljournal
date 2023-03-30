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
    @Published var searchQuery: String = ""
    @Published var showOnboarding = false
    @Published var willDeleteJournalId: String = ""
    
    private let homeUseCase: HomeUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
        initSearchJournalObserver()
        initJournalObserver()
        getOnboardingStatus()
    }
    
    deinit {
        self.cancellables.removeAll()
    }
}

// MARK: Onboarding

extension HomePresenter {
    func getOnboardingStatus() {
        guard LocalStorageManager.getValue(key: "onboarding") == nil else {
            TrackerManager.requestTrackingAuthorization()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.showOnboarding = true
        }
    }
    
    func setOnboardingDone() {
        showOnboarding = false
        LocalStorageManager.setValue(key: "onboarding", value: true)
        TrackerManager.requestTrackingAuthorization()
    }
}

// MARK: Handler

extension HomePresenter {
    func initSearchJournalObserver() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchQuery in
                guard let self = self else { return }
                self.getJournalList(query: searchQuery)
            }
            .store(in: &cancellables)
    }
    
    func initJournalObserver() {
        EventPublisher.shared.journalPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .refreshJournalList:
                    self.getJournalList(query: self.searchQuery)
                }
            }
            .store(in: &cancellables)
    }
    
    func getJournalList(query: String = "") {
        viewState = .loading
        homeUseCase.getJournalList(query: query)
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
                withAnimation {
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
        guard !id.isEmpty else { return }
        
        homeUseCase.deleteJournal(withId: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] isSuccess in
                guard let self = self else { return }
                
                self.willDeleteJournalId = ""
                if isSuccess {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        EventPublisher.shared.journalSubject.send(.refreshJournalList)
                    }
                }
            })
            .store(in: &cancellables)
    }
}
