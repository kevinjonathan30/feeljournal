//
//  ResultExtension.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import RealmSwift

public extension Results {
    public func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for index in 0 ..< count {
            if let result = self[index] as? T {
                array.append(result)
            }
        }
        return array
    }
}
