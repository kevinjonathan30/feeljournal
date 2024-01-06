//
//  JournalDetailView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 24/11/22.
//

import SwiftUI

struct JournalDetailView: View {
    @StateObject var presenter: JournalDetailPresenter
    @FocusState private var isInEditMode: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text((presenter.journal.createdAt ?? Date()).convertToFullDateInString())
                    .font(.footnote)
                Spacer()
                Text(getAverageFeelingStringByIndex())
            }
            
            TextField(
                "Untitled",
                text: $presenter.titleValue
            )
            .focused($isInEditMode)
            .font(.title2)
            .bold()
            
            ScrollView {
                VStack(alignment: .leading) {
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
            }
        }
        .padding()
        .navigationTitle("Journal Detail")
        .navigationBarTitleDisplayMode(.inline)
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
                        self.presenter.editJournal()
                    } label: {
                        Text("Done")
                            .bold()
                    }
                    .disabled(presenter.bodyValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .confirmationDialog("This action cannot be undone.", isPresented: $presenter.showConfirmationDialog, titleVisibility: .visible) { // TODO: Refactor Confirmation Dialog Usage
            Button("Delete Journal", role: .destructive) {
                self.presenter.deleteJournal()
            }
        }
    }
}

// MARK: Helper

private extension JournalDetailView {
    private func getAverageFeelingStringByIndex() -> String {
        switch presenter.feelingIndex {
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

#Preview {
    JournalDetailView(
        presenter: Provider.provideJournalDetailPresenter(
            journal: JournalModel(
                id: UUID(),
                title: "Hello world",
                createdAt: Date(),
                body: "This is a sample body",
                feelingIndex: 0
            )
        )
    )
}
