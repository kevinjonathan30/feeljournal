//
//  AddJournalView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 23/10/22.
//

import SwiftUI

struct AddJournalView: View {
    @ObservedObject var presenter: AddJournalPresenter
    
    var body: some View {
        VStack {
            switch presenter.index {
            case 0:
                titleView()
            case 1:
                bodyView()
            default:
                ProgressView()
            }
        }
        .hideKeyboardOnTap()
        .navigationTitle("Add Journal")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            presenter.resetState()
        }
        .onChange(of: presenter.isSuccess) { isSuccess in
            if isSuccess {
                NavigationController.pop()
            }
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
                .disabled(presenter.titleValue.isEmpty)
        }
    }
    
    @ViewBuilder
    func bodyView() -> some View {
        VStack {
            Text("How about the story?")
                .font(.title3)
                .bold()
            
            TextField(
                "Write it here..",
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
            
            button(text: "Done", action: {
                if !presenter.titleValue.isEmpty && !presenter.bodyValue.isEmpty {
                    self.presenter.addJournal()
                }
            }).disabled(presenter.bodyValue.isEmpty)
        }
    }
    
    @ViewBuilder
    func button(text: String, action: (() -> Void)? = nil) -> some View {
        Button(text, action: {
            withAnimation {
                if presenter.index == 0 {
                    presenter.index += 1
                }
                hideKeyboard()
                action?()
            }
        }).buttonStyle(.borderedProminent)
    }
}

struct AddJournalView_Previews: PreviewProvider {
    static var previews: some View {
        AddJournalView(presenter: AddJournalPresenter(addJournalUseCase: Provider().provideAddJournal()))
    }
}
