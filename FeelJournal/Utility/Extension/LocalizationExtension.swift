//
//  LocalizationExtension.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import Foundation

extension String {
    public func localized() -> String {
        let bundle = Bundle.main
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
