//
//  LocalStorageManager.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 24/03/23.
//

import Foundation

struct LocalStorageManager {
    static func setValue(key: String, value: Any?) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getValue(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
}
