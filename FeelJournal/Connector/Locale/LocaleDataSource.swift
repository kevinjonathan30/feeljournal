//
//  LocaleDataSource.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import Foundation
import RealmSwift
import Combine

protocol LocaleDataSourceProtocol: AnyObject {
    func getJournalList() -> AnyPublisher<[JournalEntity], Error>
    func addJournal(from journalEntity: JournalEntity) -> AnyPublisher<Bool, Error>
}

class LocaleDataSource: NSObject {
    private let realm: Realm?
    
    private init(realm: Realm?) {
        self.realm = realm
    }
    
    public static let sharedInstance: (Realm?) -> LocaleDataSource = { realmDatabase in
        return LocaleDataSource(realm: realmDatabase)
    }
}

extension LocaleDataSource: LocaleDataSourceProtocol {
    func getJournalList() -> AnyPublisher<[JournalEntity], Error> {
        return Future<[JournalEntity], Error> { completion in
            if let realm = self.realm {
                let journalEntities = {
                    realm.objects(JournalEntity.self)
                        .sorted(byKeyPath: "createdAt", ascending: false)
                }()
                completion(.success(journalEntities.toArray(ofType: JournalEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    func addJournal(
        from journalEntity: JournalEntity
    ) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(journalEntity, update: .all)
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
}
