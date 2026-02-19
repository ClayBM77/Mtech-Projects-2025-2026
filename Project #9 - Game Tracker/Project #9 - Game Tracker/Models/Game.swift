//
//  Game.swift
//  Project #9 - Game Tracker
//
//  Created by Bridger Mason on 12/11/25.
//


import Foundation
import SwiftData

@Model
class Game {
    var id: UUID
    var name: String
    var createdAt: Date
    var inGameSort: ScoreOrder
    var winnerRule: ScoreOrder
    @Relationship(deleteRule: .cascade) var players: [Player]

    init(name: String,
         inGameSort: ScoreOrder = .highest,
         winnerRule: ScoreOrder = .highest,
         players: [Player] = []) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.inGameSort = inGameSort
        self.winnerRule = winnerRule
        self.players = players
    }
}

enum ScoreOrder: String, Codable, CaseIterable, Identifiable {
    case highest
    case lowest
    var id: String { rawValue }

    var title: String {
        switch self {
        case .highest: return "Highest"
        case .lowest: return "Lowest"
        }
    }
}
