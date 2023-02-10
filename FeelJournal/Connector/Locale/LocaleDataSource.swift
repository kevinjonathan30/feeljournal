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
    func getJournalList(query: String) -> AnyPublisher<[JournalEntity], Error>
    func addJournal(from journalEntity: JournalEntity) -> AnyPublisher<Bool, Error>
    func deleteJournal(withId id: String) -> AnyPublisher<Bool, Error>
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
    func getJournalList(query: String = "") -> AnyPublisher<[JournalEntity], Error> {
        return Future<[JournalEntity], Error> { completion in
            if let realm = self.realm {
                let journalEntities = {
                    realm.objects(JournalEntity.self)
                        .sorted(byKeyPath: "createdAt", ascending: false)
                }()
                var journalEntityList = journalEntities.toArray(ofType: JournalEntity.self)
                if !query.isEmpty {
                    journalEntityList = journalEntityList.filter({ ($0.title ?? "").contains(query) || ($0.body ?? "").contains(query) })
                }
                completion(.success(journalEntityList))
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
    
    func deleteJournal(
        withId id: String
    ) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    let journals = realm.objects(JournalEntity.self).filter("id = %@", id)
                    try realm.write {
                        for journal in journals {
                            realm.delete(journal)
                        }
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
