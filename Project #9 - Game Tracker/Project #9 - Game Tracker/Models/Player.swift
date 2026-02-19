//
//  Player.swift
//  Project #9 - Game Tracker
//
//  Created by Bridger Mason on 12/11/25.
//


import Foundation
import SwiftData



@Model
class Player {
    var id: UUID
    var name: String
    var score: Int
    var createdAt: Date
    var icon: String

    init(name: String, score: Int = 0, icon: String) {
        self.id = UUID()
        self.name = name
        self.score = score
        self.createdAt = Date()
        self.icon = icon
    }
}

enum PlayerIcon: String, CaseIterable, Identifiable {
    case person = "person.fill"
    case star = "star.fill"
    case heart = "heart.fill"
    case diamond = "diamond.fill"
    case spade = "suit.spade.fill"
    case club = "suit.club.fill"
    case crown = "crown.fill"
    case flame = "flame.fill"
    case bolt = "bolt.fill"
    case trophy = "trophy.fill"
    case gameController = "gamecontroller.fill"
    case dice = "dice.fill"
    case paw = "pawprint.fill"
    case leaf = "leaf.fill"
    case sun = "sun.max.fill"
    case moon = "moon.fill"
    case sparkles = "sparkles"
    case airplane = "airplane"
    
    var id: String { rawValue }
}
