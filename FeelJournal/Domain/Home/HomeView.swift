//
//  HomeView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var presenter: HomePresenter
    
    var body: some View {
        VStack {
            ZStack {
                switch presenter.viewState {
                case .loading:
                    ProgressView()
                case .fail:
                    Text("Failed to Get Data")
                case .empty:
                    Text("No Journal")
                case .loaded:
                    loadedView()
                }
                
                floatingButton()
            }
        }
        .navigationTitle("FeelJournal")
        .searchable(text: $presenter.searchQuery)
        .sheet(isPresented: $presenter.showOnboarding) { // TODO: Onboarding
            VStack {
                Text("This is an onboarding")
                
                Button {
                    presenter.showOnboarding = false
                } label: {
                    Text("Done")
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
        }
        .interactiveDismissDisabled(true)
    }
}

// MARK: ViewBuilder

private extension HomeView {
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
                self.presenter.showConfirmationDialog = true
            } label: {
                Label("Delete Journal", systemImage: "trash.fill")
            }
        }
        .confirmationDialog("This action cannot be undone.", isPresented: $presenter.showConfirmationDialog, titleVisibility: .visible) {
            Button("Delete Journal", role: .destructive) {
                self.presenter.deleteJournal(withId: journal.id.uuidString)
            }
        }
    }
    
    @ViewBuilder
    private func floatingButton() -> some View {
        VStack {
            Spacer()
            
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(presenter: HomePresenter(homeUseCase: Provider().provideHome()))
    }
}
