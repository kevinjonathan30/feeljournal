//
//  AddJournalView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI

struct AddJournalView: View {
    @StateObject var presenter: AddJournalPresenter
    
    var body: some View {
        VStack {
            textView()
        }
        .hideKeyboardOnTap()
        .navigationTitle("Add Journal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        hideKeyboard()
                        if !presenter.bodyValue.isEmpty {
                            self.presenter.addJournal()
                        }
                    }
                } label: {
                    Text("Done")
                        .bold()
                }
                .disabled(presenter.bodyValue.isEmpty)
            }
        }
    }
}

// MARK: ViewBuilder

extension AddJournalView {
    @ViewBuilder
    func textView() -> some View {
        VStack {
            Text("How are you feeling today?")
                .font(.title3)
                .bold()
            
            TextField(
                "Write about your day here..",
                text: $presenter.bodyValue,
                axis: .vertical
            )
            .multilineTextAlignment(.leading)
            .lineLimit(10, reservesSpace: true)
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.indigo)
            )
            .padding()
        }
    }
}

struct AddJournalView_Previews: PreviewProvider {
    static var previews: some View {
        AddJournalView(presenter: Provider.provideAddJournalPresenter())
    }
}
