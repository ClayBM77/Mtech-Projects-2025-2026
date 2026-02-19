//
//  GamesListViewModel.swift
//  Project #9 - Game Tracker
//
//  Created by Bridger Mason on 12/11/25.
//

import Foundation
import SwiftData
import Observation
import SwiftUI

@Observable
class GamesListViewModel {
    private let context: ModelContext
    init(context: ModelContext) {
        self.context = context
    }
    
    func add(game: Game, using context: ModelContext) {
        // Insert players first, then the game
        // SwiftData needs players to be in the context for the relationship to work
        for player in game.players {
            context.insert(player)
        }
        context.insert(game)
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }

    /// Delete the provided games from the context.
    func delete(games: [Game], at offsets: IndexSet, using context: ModelContext) {
        for index in offsets {
            context.delete(games[index])
        }
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }

    
    func move(games: inout [Game], from source: IndexSet, to destination: Int, using context: ModelContext) {
        games.move(fromOffsets: source, toOffset: destination)
        // Persist order by adjusting createdAt so visual order is stable after a refetch
        var current = Date()
        for game in games {
            game.createdAt = current
            current.addTimeInterval(-1)
        }
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}

