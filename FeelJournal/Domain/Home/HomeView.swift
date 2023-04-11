//
//  HomeView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var presenter: HomePresenter
    
    var body: some View {
        VStack {
            switch presenter.viewState {
            case .loading:
                ProgressView()
            case .fail:
                headlineText(text: "Failed to Get Journal Data")
            case .empty:
                headlineText(text: "No Journal")
            case .loaded:
                loadedView()
            }
        }
        .overlay(floatingButton(), alignment: .bottom)
        .navigationTitle("FeelJournal")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $presenter.searchQuery) // FIXME: Search Bar Scrolling Bug
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    NavigationController.push(.settings)
                } label: {
                    Image(systemName: "gearshape.fill")
                }
            }
        }
        .sheet(isPresented: $presenter.showOnboarding) {
            OnboardingView()
                .action {
                    presenter.setOnboardingDone()
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled(true)
        }
    }
}

// MARK: ViewBuilder

private extension HomeView {
    @ViewBuilder
    private func headlineText(text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.gray)
    }
    
    @ViewBuilder
    private func loadedView() -> some View {
        ScrollView {
            LazyVStack {
                ForEach(presenter.journals) { journal in
                    cardView(journal: journal)
                }
            }
        }
        .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
    }
    
    @ViewBuilder
    private func cardView(journal: JournalModel) -> some View {
        CommonCard(
            leading: AnyView(Text(getFeelingByIndex(feelingIndex: journal.feelingIndex ?? 0.0))),
            title: (journal.createdAt ?? Date()).convertToFullDateInString(),
            subtitle: journal.body ?? ""
        )
        .action {
            NavigationController.push(.journalDetail(journal))
        }
        .contextMenu {
            Button {
                NavigationController.push(.journalDetail(journal))
            } label: {
                Label("View Detail", systemImage: "book.fill")
            }
            
            Button(role: .destructive) {
                self.presenter.willDeleteJournalId = journal.id.uuidString
            } label: {
                Label("Delete Journal", systemImage: "trash.fill")
            }
        } preview: {
            JournalDetailView(
                presenter: Provider.provideJournalDetailPresenter(
                    journal: journal
                )
            )
            .id(UUID())
            .frame(idealWidth: UIScreen.main.bounds.width)
        }
        .confirmationDialog(
            "This action cannot be undone.",
            isPresented: .constant(!presenter.willDeleteJournalId.isEmpty),
            titleVisibility: .visible
        ) {
            Button("Delete Journal", role: .destructive) {
                self.presenter.deleteJournal(withId: presenter.willDeleteJournalId)
            }
        }
    }
    
    @ViewBuilder
    private func floatingButton() -> some View {
        VStack {
            Button {
                NavigationController.push(.addJournal)
            } label: {
                Image(systemName: "plus")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Capsule(style: .continuous)
                            .background(.indigo)
                            .clipShape(Capsule())
                    )
            }
        }
        .transaction { transaction in
            transaction.animation = .none
        }
    }
}

// MARK: Helper

private extension HomeView {
    private func getFeelingByIndex(feelingIndex: Double) -> String {
        switch feelingIndex {
        case let value where value > 0 && value <= 1:
            return "😀"
        case let value where value < 0 && value >= -1:
            return "😢"
        case 0:
            return "😐"
        default:
            return "❓"
        }
    }
}

// MARK: Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(presenter: Provider.provideHomePresenter())
    }
}
