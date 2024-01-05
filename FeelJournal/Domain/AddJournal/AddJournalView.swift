//
//  AddJournalView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI

struct AddJournalView: View {
    @StateObject var presenter: AddJournalPresenter
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
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
                .overlay( // TODO: Change to Color Scheme
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.indigo)
                )
                .padding()
            }
        }
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
                .disabled(presenter.bodyValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .hideKeyboardOnTap()
    }
}

// MARK: Helper

private extension AddJournalView {
    private func getColorScheme() -> Color {
        if colorScheme == .dark {
            return .indigo.opacity(0.2)
        }
        return .indigo.opacity(0.1)
    }
}

// MARK: Preview

#Preview {
    AddJournalView(
        presenter: Provider.provideAddJournalPresenter()
    )
}
