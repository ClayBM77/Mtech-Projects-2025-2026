//
//  GameDetailViewModel.swift
//  Project #9 - Game Tracker
//
//  Created by Bridger Mason on 12/11/25.
//


import Foundation
import SwiftData
import SwiftUI
@Observable

class GameDetailViewModel {
    var game: Game
    //private let context: ModelContext

    init(game: Game) {
        self.game = game
        //self.context = context
        sortPlayers()
    }

    func addPlayer(named name: String, icon: String) {
        let player = Player(name: name, icon: icon)
        game.players.append(player)
        sortPlayers()
        save()
    }

    func deletePlayers(at offsets: IndexSet) {
        // Convert IndexSet to array of players to delete
        let playersToDelete = offsets.map { game.players[$0] }
        for player in playersToDelete {
            game.modelContext?.delete(player)
        }
        sortPlayers()
        save()
    }

    func movePlayers(from source: IndexSet, to destination: Int) {
        game.players.move(fromOffsets: source, toOffset: destination)
        save()
    }

    func changeScore(for player: Player, by point: Int) {
        player.score += point
        sortPlayers()
        save()
    }

    func sortPlayers() {
        switch game.inGameSort {
        case .highest:
            game.players.sort { $0.score > $1.score }
        case .lowest:
            game.players.sort { $0.score < $1.score }
        }
    }

    var winnerText: String {
        guard let winner = game.players.sorted(by: {
            switch game.winnerRule {
            case .highest: return $0.score > $1.score
            case .lowest: return $0.score < $1.score
            }
        }).first else { return "No players" }
        return "Winner: \(winner.name) (\(winner.score))"
    }

    private func save() {
        do { try game.modelContext?.save() } catch { print("Save error: \(error)") }
    }
}
