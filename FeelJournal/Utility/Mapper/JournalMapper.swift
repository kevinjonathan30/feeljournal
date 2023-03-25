//
//  JournalMapper.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import Foundation

class JournalMapper {
    // MARK: Entity to Model
    
    static func mapJournalEntityListToModelList(
        input journalEntities: [JournalEntity]
    ) -> [JournalModel] {
        return journalEntities.map { result in
            return JournalModel(
                id: UUID(uuidString: result.id ?? "") ?? UUID(),
                title: result.title,
                createdAt: result.createdAt,
                body: result.body,
                feelingIndex: result.feelingIndex
            )
        }
    }
    
    // MARK: Model to Entity
    
    static func mapJournalModelToEntity(
        input journalModel: JournalModel
    ) -> JournalEntity {
        let journalEntity = JournalEntity()
        journalEntity.id = journalModel.id.uuidString
        journalEntity.title = journalModel.title
        journalEntity.createdAt = journalModel.createdAt
        journalEntity.body = journalModel.body
        journalEntity.feelingIndex = journalModel.feelingIndex
        return journalEntity
    }
}
