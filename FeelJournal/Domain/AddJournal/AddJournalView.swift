//
//  AddJournalView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI

struct AddJournalView: View {
    @EnvironmentObject private var router: Router<Path>
    @ObservedObject var presenter: AddJournalPresenter
    
    var body: some View {
        VStack {
            switch presenter.index {
            case 0:
                titleView()
            default:
                bodyView()
            }
        }
        .hideKeyboardOnTap()
        .navigationTitle("Add Journal")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            presenter.resetState()
        }
    }
}

extension AddJournalView {
    @ViewBuilder
    func titleView() -> some View {
        VStack {
            Text("Write down your today's chapter!")
                .font(.title3)
                .bold()
            
            TextField(
                "Untitled",
                text: $presenter.titleValue,
                axis: .vertical
            )
            .lineLimit(5)
            .font(.headline)
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.indigo)
            )
            .padding()
            
            button(text: "Next")
        }
    }
    
    @ViewBuilder
    func bodyView() -> some View {
        VStack {
            Text("How about the story?")
                .font(.title3)
                .bold()
            
            TextEditor(text: $presenter.bodyValue)
                .autocorrectionDisabled()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.indigo)
                )
                .padding()
                .frame(
                    height: UIScreen.main.bounds.height * 0.3
                )
            
            button(text: "Done", action: {
                if !presenter.titleValue.isEmpty && !presenter.bodyValue.isEmpty {
                    self.presenter.addJournal {
                        self.router.pop()
                    }
                }
            })
        }
    }
    
    @ViewBuilder
    func button(text: String, action: (() -> Void)? = nil) -> some View {
        Button(text, action: {
            withAnimation(.spring()) {
                if presenter.index == 0 {
                    presenter.index += 1
                }
                hideKeyboard()
                action?()
            }
        })
    }
}

struct AddJournalView_Previews: PreviewProvider {
    static var previews: some View {
        AddJournalView(presenter: AddJournalPresenter(addJournalUseCase: Provider().provideAddJournal()))
    }
}
