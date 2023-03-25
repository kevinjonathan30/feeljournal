//
//  JournalDetailView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 24/11/22.
//

import SwiftUI

struct JournalDetailView: View {
    @ObservedObject var presenter: JournalDetailPresenter
    @FocusState private var isInEditMode: Bool
    let journal: JournalModel
    
    init(presenter: JournalDetailPresenter, journal: JournalModel) {
        self.presenter = presenter
        self.journal = journal
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text((journal.createdAt ?? Date()).convertToFullDateInString())
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 8)
                
                TextField(
                    "Write about your day here..",
                    text: $presenter.bodyValue,
                    axis: .vertical
                )
                .focused($isInEditMode)
                .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Journal Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.presenter.bodyValue = journal.body ?? ""
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        self.presenter.showConfirmationDialog = true
                    } label: {
                        Label("Delete Journal", systemImage: "trash.fill")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                
                if isInEditMode {
                    Button {
                        self.isInEditMode = false
                        self.presenter.editJournal(journal: journal)
                    } label: {
                        Text("Done")
                            .bold()
                    }
                }
            }
        }
        .confirmationDialog("This action cannot be undone.", isPresented: $presenter.showConfirmationDialog, titleVisibility: .visible) { // TODO: Refactor Confirmation Dialog Usage
            Button("Delete Journal", role: .destructive) {
                self.presenter.deleteJournal(withId: journal.id.uuidString)
            }
        }
    }
}

struct JournalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let journal = JournalModel(
            id: UUID(),
            title: "Hello world",
            createdAt: Date(),
            body: "This is a sample body",
            feelingIndex: 0
        )
        JournalDetailView(
            presenter: JournalDetailPresenter(journalDetailUseCase: Provider().provideJournalDetail()),
            journal: journal
        )
    }
}
