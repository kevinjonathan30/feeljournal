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
        let sentiment = tagger.tag(at: input.startIndex, unit: .paragraph, scheme: .sentimentScore).0
        let score = Double(sentiment?.rawValue ?? "0") ?? 0
        return score
    }
}
