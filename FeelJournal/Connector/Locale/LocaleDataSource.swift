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
    func addEditJournal(from journalEntity: JournalEntity) -> AnyPublisher<Bool, Error>
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
        guard let realm = self.realm else {
            return Fail(error: DatabaseError.invalidInstance).eraseToAnyPublisher()
        }
        
        var journalEntities = realm.objects(JournalEntity.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .toArray(ofType: JournalEntity.self)
        
        if !query.isEmpty {
            journalEntities = journalEntities.filter({ ($0.title?.lowercased() ?? "").contains(query.lowercased()) || ($0.body?.lowercased() ?? "").contains(query.lowercased()) })
        }
        
        return Just(Array(journalEntities)).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func addEditJournal(from journalEntity: JournalEntity) -> AnyPublisher<Bool, Error> {
        guard let realm = self.realm else {
            return Fail(error: DatabaseError.invalidInstance).eraseToAnyPublisher()
        }
        
        do {
            try realm.write {
                realm.add(journalEntity, update: .all)
            }
            return Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: DatabaseError.requestFailed).eraseToAnyPublisher()
        }
    }
    
    func deleteJournal(withId id: String) -> AnyPublisher<Bool, Error> {
        guard let realm = self.realm else {
            return Fail(error: DatabaseError.invalidInstance).eraseToAnyPublisher()
        }
        
        do {
            let journals = realm.objects(JournalEntity.self).filter("id = %@", id)
            try realm.write {
                realm.delete(journals)
            }
            return Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: DatabaseError.requestFailed).eraseToAnyPublisher()
        }
    }
}
