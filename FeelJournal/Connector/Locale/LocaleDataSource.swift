//
//  LocaleDataSource.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import Foundation
import RealmSwift
import Combine

public protocol LocaleDataSourceProtocol: AnyObject {
    func getJournalList() -> AnyPublisher<[JournalEntity], Error>
}

public class LocaleDataSource: NSObject {
    private let realm: Realm?
    
    private init(realm: Realm?) {
        self.realm = realm
    }
    
    public static let sharedInstance: (Realm?) -> LocaleDataSource = { realmDatabase in
        return LocaleDataSource(realm: realmDatabase)
    }
}

extension LocaleDataSource: LocaleDataSourceProtocol {
    public func getJournalList() -> AnyPublisher<[JournalEntity], Error> {
        return Future<[JournalEntity], Error> { completion in
            if let realm = self.realm {
                let journalEntities = {
                    realm.objects(JournalEntity.self)
                }()
                completion(.success(journalEntities.toArray(ofType: JournalEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
}
