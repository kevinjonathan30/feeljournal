//
//  DateHelper.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 25/03/23.
//

import Foundation

struct DateHelper {
    // Convert Date to String
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
