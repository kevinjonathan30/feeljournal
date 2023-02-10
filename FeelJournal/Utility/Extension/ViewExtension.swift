//
//  ViewExtension.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        modifier(HideKeyboardModifier())
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
