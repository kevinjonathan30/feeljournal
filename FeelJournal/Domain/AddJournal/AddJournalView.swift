//
//  AddJournalView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI

struct AddJournalView: View {
    @StateObject var presenter: AddJournalPresenter
    @FocusState private var isInEditMode: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TextField(
                    "How are you feeling today?",
                    text: $presenter.titleValue
                )
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
        .onAppear {
            isInEditMode = true
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
