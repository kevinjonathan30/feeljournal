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
                        CardView(data: data)
                    }
                }
            }
            
            FloatingButton()
                .zIndex(999)
        }
        .navigationTitle("FeelJournal")
        .refreshable {
            presenter.getJournalList()
        }
    }
}

private extension HomeView {
    @ViewBuilder
    private func CardView(data: Journal) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(.indigo)
            
            HStack {
                Text("\(data.feelingIndex > 0 ? "😀" : "😢")")
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(data.title ?? "")
                            .foregroundColor(.white)
                            .bold()
                        
                        Spacer()
                        
                        Text("\(data.createdAt?.formatted(date: .abbreviated, time: .omitted) ?? Date().formatted(date: .abbreviated, time: .omitted))")
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
    private func FloatingButton() -> some View {
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
