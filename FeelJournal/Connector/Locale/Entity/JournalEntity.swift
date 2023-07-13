//
//  JournalEntity.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import Foundation
import RealmSwift

public class JournalEntity: Object {
    @Persisted var id: String?
    @Persisted var title: String?
    @Persisted var createdAt: Date?
    @Persisted var updatedAt: Date?
    @Persisted var body: String?
    @Persisted var feelingIndex: Double?
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}
