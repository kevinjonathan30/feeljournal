//
//  FeelJournalAppCheckProviderFactory.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 26/03/23.
//

import Foundation
import Firebase

class FeelJournalAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    return AppAttestProvider(app: app)
  }
}

