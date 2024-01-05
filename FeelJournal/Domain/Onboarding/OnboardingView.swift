//
//  OnboardingView.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 25/03/23.
//

import SwiftUI

struct OnboardingView: View {
    var action: (() -> Void)?
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("FeelJournal")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            featureListView()
            
            Spacer()
            
            Button {
                action?()
            } label: {
                Text("Continue")
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .background(
                        Capsule(style: .continuous)
                            .background(.indigo)
                            .clipShape(Capsule())
                    )
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: ViewBuilder

private extension OnboardingView {
    @ViewBuilder
    func featureListView() -> some View {
        VStack(alignment: .leading) {
            featureView(
                image: "book.circle.fill",
                headline: "Write Your Story",
                subheadline: "Write your journal and capture your feeling in FeelJournal."
            )
            
            featureView(
                image: "heart.circle.fill",
                headline: "Track Overall Feeling",
                subheadline: "FeelJournal will summarize your overall feeling based on your writing."
            )
            
            featureView(
                image: "bell.circle.fill",
                headline: "Never Forget to Write Again",
                subheadline: "FeelJournal can help to remind you to write your journal everyday."
            )
        }
    }
    
    @ViewBuilder
    func featureView(image: String, headline: String, subheadline: String) -> some View {
        HStack {
            Image(systemName: image)
                .foregroundColor(.indigo)
                .font(.largeTitle)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(headline)
                    .font(.headline)
                    .bold()
                
                Text(subheadline)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .multilineTextAlignment(.leading)
        }
        .padding()
    }
}

// MARK: Public Modifier

extension OnboardingView {

    /// action
    /// - Parameter action: runs an action everytime the button is tapped
    /// - Returns: OnboardingView
    func action(_ action: @escaping(() -> Void)) -> Self {
        var copy = self
        copy.action = action
        return copy
    }
}

// MARK: Preview

#Preview {
    OnboardingView()
}
