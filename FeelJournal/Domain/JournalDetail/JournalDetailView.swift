//
//  JournalDetailView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 24/11/22.
//

import SwiftUI

struct JournalDetailView: View {
    let journal: JournalModel
    
    init(journal: JournalModel) {
        self.journal = journal
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text((journal.createdAt ?? Date()).convertToFullDateInString())
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 8)
                
                Text(journal.body ?? "")
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Journal Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct JournalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let journal = JournalModel(
            id: UUID(),
            title: "Hello world",
            createdAt: Date(),
            body: "This is a sample body",
            feelingIndex: 0,
            audioUrl: ""
        )
        JournalDetailView(journal: journal)
    }
}
