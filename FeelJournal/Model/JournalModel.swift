//
//  Journal.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 22/11/22.
//

import Foundation

struct JournalModel: Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String?
    var createdAt: Date?
    var body: String?
    var feelingIndex: Double?
}
