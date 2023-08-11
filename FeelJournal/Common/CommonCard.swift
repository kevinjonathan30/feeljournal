//
//  CommonCard.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 10/03/23.
//

import SwiftUI

struct CommonCard: View {
    @Environment(\.colorScheme) var colorScheme
    
    private let leading: AnyView?
    private let title: String
    private let subtitle: String?
    var action: (() -> Void)?
    
    /// CommonCard: Used to create a view of card
    /// - Parameters:
    ///   - leading: Card leading
    ///   - title: Card title
    ///   - subtitle: Card subtitle
    init(leading: AnyView?, title: String, subtitle: String?) {
        self.leading = leading
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack {
            if let leading = leading {
                leading
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .bold()
                        .opacity(0.8)
                    
                    Spacer()
                    
                    if action != nil {
                        Image(systemName: "chevron.right")
                            .opacity(0.5)
                    }
                }.padding(.bottom, 1)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .lineLimit(1)
                        .opacity(0.5)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(getColorScheme())
        )
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onTapGesture {
            action?()
        }
    }
}

// MARK: Helper

private extension CommonCard {
    private func getColorScheme() -> Color {
        if colorScheme == .dark {
            return .indigo.opacity(0.2)
        }
        return .indigo.opacity(0.1)
    }
}

// MARK: Public Modifier

extension CommonCard {

    /// action
    /// - Parameter action: runs an action everytime the card is tapped
    /// - Returns: CommonCard
    func action(_ action: @escaping(() -> Void)) -> Self {
        var copy = self
        copy.action = action
        return copy
    }
}
