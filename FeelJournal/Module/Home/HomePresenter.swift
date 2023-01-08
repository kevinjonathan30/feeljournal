//
//  HomePresenter.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI

class HomePresenter: ObservableObject {
    @Published var datas: [Journal] = []
    
    init() {
        getJournalList()
    }
}

extension HomePresenter {
    func getJournalList() {
        datas = []
        withAnimation {
            datas.append(Journal(title: "Hi", createdAt: Date(), body: "Hello there!", feelingIndex: 0.7))
            datas.append(Journal(title: "I am sad today", createdAt: Date(), body: "Why is this happening, i am literally very sad and want to cry", feelingIndex: -0.3))
        }
    }
}
