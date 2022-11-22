//
//  HomeView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI

struct HomeView: View {
    var datas = [Journal(title: "Hi", createdAt: Date(), body: "Hello there!", feelingIndex: 0.7), Journal(title: "I am sad today", createdAt: Date(), body: "Why is this happening, i am literally very sad and want to cry", feelingIndex: -0.3)]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(datas) { data in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.indigo)
                            
                            HStack {
                                Text("\(data.feelingIndex > 0 ? "😀" : "😢")")
                                
                                VStack(alignment: .leading) {
                                    Text(data.title ?? "")
                                        .foregroundColor(.white)
                                        .bold()
                                    
                                    Text(data.body ?? "")
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Text("\(data.createdAt?.formatted(date: .abbreviated, time: .omitted) ?? Date().formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            }.padding(16)
                        }.padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    }
                }
            }
            .navigationTitle("FeelJournal")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
