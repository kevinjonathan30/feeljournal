//
//  Path.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 19/01/23.
//

import Foundation

enum Path: Hashable {    
    case root
    case addJournal
    case journalDetail(JournalModel)
}
