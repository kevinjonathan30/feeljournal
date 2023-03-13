//
//  DateExtension.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 10/03/23.
//

import Foundation

extension Date {
    func convertToFullDateInString() -> String {
        return self.formatted(date: .abbreviated, time: .shortened)
    }
}
