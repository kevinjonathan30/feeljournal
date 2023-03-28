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
    @Published var showConfirmationDialog = false
    @Published var showOnboarding = false
    
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
        if LocalStorageManager.getValue(key: "onboarding") == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.showOnboarding = true
            }
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
                default:
                    break
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
        homeUseCase.deleteJournal(withId: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] isSuccess in
                guard let self = self else { return }
                if isSuccess {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            self.journals.removeAll { $0.id == UUID(uuidString: id) }
                            EventPublisher.shared.journalSubject.send(.refreshAnalytics)
                            
                            if self.journals.isEmpty {
                                self.viewState = .empty
                            }
                        }
                    }
                }
            })
            .store(in: &cancellables)
    }
}
