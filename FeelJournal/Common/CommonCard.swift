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
    private let headline: String
    private let title: String
    private let subtitle: String?
    var action: (() -> Void)?
    
    /// CommonCard: Used to create a view of card
    /// - Parameters:
    ///   - leading: Card leading
    ///   - title: Card title
    ///   - subtitle: Card subtitle
    init(leading: AnyView?, headline: String, title: String, subtitle: String?) {
        self.leading = leading
        self.headline = headline
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    Text(headline)
                        .font(.caption)
                        .foregroundStyle(.indigo)
                        .bold()
                    
                    Spacer()
                }.padding(.bottom, 1)
                
                HStack {
                    Text(title)
                        .bold()
                        .opacity(0.8)
                    
                    Spacer()
                }.padding(.bottom, 1)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .lineLimit(5)
                        .opacity(0.5)
                }
            }
            
            if let leading = leading {
                leading
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(getQuaternaryColor()) // TODO: Change to Color Scheme
                .opacity(0.5)
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
    
    private func getQuaternaryColor() -> HierarchicalShapeStyle {
        return .quaternary
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
