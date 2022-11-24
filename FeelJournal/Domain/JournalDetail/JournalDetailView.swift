//
//  JournalDetailView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 24/11/22.
//

import SwiftUI

struct JournalDetailView: View {
    @EnvironmentObject var router: Router<Path>
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        VStack {
            Text(title)
            
            Button(action: {
                router.push(.journalDetail(title))
            }, label: {
                Text("View Detail")
            })
            
            Button(action: {
                router.popToRoot()
            }, label: {
                Text("Back")
            })
        }
        .navigationTitle("Journal Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct JournalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        JournalDetailView(title: "Hello, World!")
    }
}
