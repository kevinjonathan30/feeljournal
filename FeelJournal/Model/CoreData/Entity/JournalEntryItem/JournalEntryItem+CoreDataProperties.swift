//
//  JournalEntryItem+CoreDataProperties.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 21/11/22.
//
//

import Foundation
import CoreData


extension JournalEntryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalEntryItem> {
        return NSFetchRequest<JournalEntryItem>(entityName: "JournalEntryItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var body: String?
    @NSManaged public var feelingIndex: Double

}

extension JournalEntryItem : Identifiable {

}
