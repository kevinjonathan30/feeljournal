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
        let tagger = createNLTagger(input: input)
        guard isValidLanguage(tagger: tagger) else { return -2 }
        
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation]
        let range = input.startIndex..<input.endIndex
        var totalScore = 0.0
        var tagCount = 0
        
        enumerateTags(tagger: tagger, range: range, options: options) { tag, _ in
            processTag(tag: tag, totalScore: &totalScore, tagCount: &tagCount)
            return true
        }
        
        return calculateAverageScore(totalScore: totalScore, tagCount: tagCount)
    }
}

// MARK: Handler

private extension NaturalLanguageProcessor {
    private static func createNLTagger(input: String) -> NLTagger {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = input
        return tagger
    }
    
    private static func isValidLanguage(tagger: NLTagger) -> Bool {
        return tagger.dominantLanguage != NLLanguage.undetermined
    }
    
    private static func calculateAverageScore(totalScore: Double, tagCount: Int) -> Double {
        return tagCount > 0 ? totalScore / Double(tagCount) : 0
    }
    
    private static func processTag(tag: NLTag?, totalScore: inout Double, tagCount: inout Int) {
        if let tag = tag, let score = Double(tag.rawValue) {
            totalScore += score
            tagCount += 1
        }
    }
    
    private static func enumerateTags(tagger: NLTagger, range: Range<String.Index>, options: NLTagger.Options, completion: @escaping (NLTag?, Range<String.Index>) -> Bool) {
        tagger.enumerateTags(in: range, unit: .sentence, scheme: .sentimentScore, options: options, using: completion)
    }
}
