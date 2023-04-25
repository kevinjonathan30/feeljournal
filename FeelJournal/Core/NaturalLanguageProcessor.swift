//
//  NaturalLanguageProcessor.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 03/02/23.
//

import Foundation
import NaturalLanguage

struct NaturalLanguageProcessor {
    static func processSentimentAnalysis(input: String) -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = input
        
        guard tagger.dominantLanguage != NLLanguage.undetermined else { return -2 }
        
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation]
        let range = input.startIndex..<input.endIndex
        var totalScore = 0.0
        var tagCount = 0
        
        tagger.enumerateTags(in: range, unit: .sentence, scheme: .sentimentScore, options: options) { tag, _ in
            if let tag = tag, let score = Double(tag.rawValue) {
                totalScore += score
                tagCount += 1
            }
            return true
        }
        
        if tagCount > 0 {
            let averageScore = totalScore / Double(tagCount)
            return averageScore
        } else {
            return 0
        }
    }
}
