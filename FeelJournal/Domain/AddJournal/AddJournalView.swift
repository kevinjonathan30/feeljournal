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
            VStack(alignment: .leading) {
                Text("How are you feeling today?")
                    .font(.title2)
                
                HStack {
                    Button {
                        
                    } label: {
                        VStack {
                            Text("😢")
                                .font(.title)
                            
                            Text("Sad")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.indigo)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Button {
                        
                    } label: {
                        VStack {
                            Text("😐")
                                .font(.title)
                            
                            Text("Neutral")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.indigo)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Button {
                        
                    } label: {
                        VStack {
                            Text("😀")
                                .font(.title)
                            
                            Text("Happy")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.indigo)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }.padding(.vertical)
                
                Text("Describe your state of mind")
                    .font(.title2)
                
                TextField(
                    "Write here..",
                    text: $presenter.bodyValue,
                    axis: .vertical
                )
                .multilineTextAlignment(.leading)
                .lineLimit(10, reservesSpace: true)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(getColorScheme())
                )
            }
            .padding()
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
                .disabled(presenter.bodyValue.isEmpty)
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

struct AddJournalView_Previews: PreviewProvider {
    static var previews: some View {
        AddJournalView(presenter: Provider.provideAddJournalPresenter())
    }
}
