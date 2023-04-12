//
//  CommonFloatingButton.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 12/04/23.
//

import SwiftUI

struct CommonFloatingButton: View {
    private let systemIconName: String
    var action: (() -> Void)? = { NavigationController.push(.addJournal) }
    
    /// CommonFloatingButton: Used to create a view of floating button
    /// - Parameters:
    ///   - systemIconName: Floating button icon system name
    init(systemIconName: String = "plus") {
        self.systemIconName = systemIconName
    }
    
    var body: some View {
        VStack {
            Button {
                action?()
            } label: {
                Image(systemName: systemIconName)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Capsule(style: .continuous)
                            .background(.indigo)
                            .clipShape(Capsule())
                    )
            }
        }
        .transaction { transaction in
            transaction.animation = .none
        }
    }
}

// MARK: Public Modifier

extension CommonFloatingButton {

    /// action
    /// - Parameter action: runs an action everytime the floating button is tapped
    /// - Returns: CommonFloatingButton
    func action(_ action: @escaping(() -> Void)) -> Self {
        var copy = self
        copy.action = action
        return copy
    }
}

