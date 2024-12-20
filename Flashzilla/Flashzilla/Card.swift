//
//  Card.swift
//  Flashzilla
//
//  Created by Eugene Evgen on 28/11/2024.
//

import Foundation

struct Card: Codable, Identifiable {
    var id = UUID()
    var prompt: String
    var answer: String
    
    static let example = Card(prompt: "What is capital city of Ukraine?", answer: "Kyiv")
}
