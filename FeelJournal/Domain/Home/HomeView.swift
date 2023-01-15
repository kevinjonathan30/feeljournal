//
//  HomeView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var presenter: HomePresenter
    @EnvironmentObject private var router: Router<Path>
    
    init(presenter: HomePresenter = .init()) {
        _presenter = ObservedObject(wrappedValue: presenter)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(presenter.datas) { data in
                        cardView(data: data)
                    }
                }
            }
            
            floatingButton()
                .zIndex(999)
        }
        .navigationTitle("FeelJournal")
        .refreshable {
            presenter.getJournalList()
        }
    }
}

// MARK: ViewBuilder

private extension HomeView {
    @ViewBuilder
    private func cardView(data: Journal) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(.indigo)
            
            HStack {
                Text(getFeelingByIndex(feelingIndex: data.feelingIndex))
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(data.title ?? "")
                            .foregroundColor(.white)
                            .bold()
                        
                        Spacer()
                        
                        Text(getCreatedDate(createdAt: data.createdAt))
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                    
                    Text(data.body ?? "")
                        .foregroundColor(.white)
                }
            }.padding(16)
        }
        .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .onTapGesture {
            router.push(.journalDetail(data.title ?? ""))
        }
    }
    
    @ViewBuilder
    private func floatingButton() -> some View {
        VStack {
            Spacer()
            
            Button(action: {
                router.push(.addJournal)
            }) {
                Text("Add New Note")
                    .bold()
                    .padding()
                    .background(
                        Capsule(style: .continuous)
                            .strokeBorder(.indigo, lineWidth: 3)
                            .background(.background)
                            .clipShape(Capsule())
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
        HomeView()
    }
}
