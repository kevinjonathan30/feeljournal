//
//  HomeView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: Router<Path>
    @ObservedObject var presenter: HomePresenter
    
    var body: some View {
        VStack {
            switch presenter.viewState {
            case .loading:
                ProgressView()
            case .fail:
                Text("Failed to Get Data")
            case .empty:
                Text("No Journal")
            case .loaded:
                ScrollView {
                    LazyVStack {
                        ForEach(presenter.journals) { journal in
                            cardView(journal: journal)
                        }
                    }
                }
            }
        }
        .navigationTitle("FeelJournal")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    router.push(.addJournal)
                }) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.indigo)
                }
            }
        }
        .onAppear {
            presenter.getJournalList()
        }
    }
}

// MARK: ViewBuilder

private extension HomeView {
    @ViewBuilder
    private func cardView(journal: JournalModel) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(.indigo)
            
            HStack {
                Text(getFeelingByIndex(feelingIndex: journal.feelingIndex ?? 0.0))
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(journal.title ?? "")
                            .foregroundColor(.white)
                            .bold()
                        
                        Spacer()
                        
                        Text(getCreatedDate(createdAt: journal.createdAt))
                            .font(.caption2)
                            .foregroundColor(.white)
                    }.padding(.bottom, 1)
                    
                    Text(journal.body ?? "")
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
            }.padding(16)
        }
        .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .onTapGesture {
            router.push(.journalDetail(journal.title ?? ""))
        }
    }
    
    @ViewBuilder
    private func floatingButton() -> some View {
        VStack {
            Spacer()
            
            Button(action: {
                router.push(.addJournal)
            }) {
                Text("Add New Journal")
                    .bold()
                    .padding()
                    .background(
                        Capsule(style: .continuous)
                            .strokeBorder(.indigo, lineWidth: 3)
                            .background(.background)
                            .clipShape(Capsule())
                            .shadow(color: Color.accentColor, radius: 4)
                    )
            }
            .padding(.bottom)
        }
    }
}

// MARK: Helper

private extension HomeView {
    private func getFeelingByIndex(feelingIndex: Double) -> String {
        return feelingIndex > 0 ? "😀" : "😢"
    }
    private func getCreatedDate(createdAt: Date?) -> String {
        return "\(createdAt?.formatted(date: .abbreviated, time: .omitted) ?? Date().formatted(date: .abbreviated, time: .omitted))"
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(presenter: HomePresenter(homeUseCase: Provider().provideHome()))
    }
}
