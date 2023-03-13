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
            switch presenter.viewState {
            case .selectMenu:
                selectView()
            case .audio:
                audioView()
            case .text:
                textView()
            }
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
        .onAppear {
            presenter.resetState()
        }
    }
}

extension AddJournalView {
    @ViewBuilder
    func selectView() -> some View {
        VStack {
            Spacer()
            
            Text("Use Voice Record?")
                .font(.title3)
                .bold()
            
            Spacer()
            
            CommonCard(
                leading: AnyView(
                    Image(systemName: "waveform.circle.fill")
                        .font(.system(size: 48))
                        .padding()
                        .foregroundColor(.indigo)
                ),
                title: "Use Voice",
                subtitle: "Record with voice"
            )
            .action {
                withAnimation {
                    presenter.viewState = .audio
                }
            }
            .opacity(0.2)
            .disabled(true) // TODO: Re-enable once voice feature is developed
            
            CommonCard(
                leading: AnyView(
                    Image(systemName: "square.and.pencil.circle.fill")
                        .font(.system(size: 48))
                        .padding()
                        .foregroundColor(.indigo)
                ),
                title: "Don't Use Voice",
                subtitle: "Type with keyboard"
            )
            .action {
                withAnimation {
                    presenter.viewState = .text
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    func audioView() -> some View {
        VStack {
            Text("How are you feeling today?")
                .font(.title3)
                .bold()
            
            Button {
                print("Play")
            } label: {
                Image(systemName: "mic.circle.fill")
                    .font(.system(size: 48))
            }
            .padding()
        }
    }
    
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
        AddJournalView(presenter: AddJournalPresenter(addJournalUseCase: Provider().provideAddJournal()))
    }
}
