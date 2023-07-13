//
//  LocalStorageManager.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 24/03/23.
//

import Foundation
import RealmSwift

struct LocalStorageManager {
    static func setValue(key: String, value: Any?) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getValue(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    static func migrateRealm() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    migration.enumerateObjects(ofType: JournalEntity.className()) { oldJournal, newJournal in
                        newJournal?["updatedAt"] = oldJournal?["createdAt"]
                    }
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
    }
}
