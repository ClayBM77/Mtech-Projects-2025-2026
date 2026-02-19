//
//  NewGameView.swift
//  Project #9 - Game Tracker
//
//  Created by Bridger Mason on 12/11/25.
//


import SwiftUI
import SwiftData

struct NewGameView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = "Fortnite Match"
    @State private var inGameSort: ScoreOrder = .highest
    @State private var winnerRule: ScoreOrder = .highest
    @State private var players: [Player] = []
    @State private var newPlayerName: String = ""
    @State private var icon: String = PlayerIcon.dice.rawValue
    var onSave: (Game) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Game")) {
                    TextField("Name", text: $name)
                    Picker("Sort during game", selection: $inGameSort) {
                        ForEach(ScoreOrder.allCases) { order in
                            Text(order.title).tag(order)
                        }
                    }
                    Picker("Winner rule", selection: $winnerRule) {
                        ForEach(ScoreOrder.allCases) { order in
                            Text(order.title).tag(order)
                        }
                    }
                }

                Section(header: Text("Players")) {
                    HStack {
                        TextField("Add player", text: $newPlayerName)
                        Button("Add") {
                            let trimmedName = newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmedName.isEmpty else { return }
                            // MARK: - withAnimation example: Animate player being added to new game with bounce
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                                players.append(Player(name: trimmedName, icon: icon))
                                newPlayerName = ""
                                icon = PlayerIcon.dice.rawValue // Reset to default
                                sortPlayers()
                            }
                        }
                    }
                    IconPickerView(selectedIcon: $icon)
                        .frame(height: 200)
                    ForEach(players, id: \.id) { player in
                        HStack {
                            Image(systemName: player.icon)
                            Text(player.name)
                            Spacer()
                            Text("\(player.score)")
                                .foregroundStyle(.secondary)
                        }
                        // MARK: - .transition example: Players in new game view scale and fade in with slide
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.5).combined(with: .opacity).combined(with: .move(edge: .top)),
                            removal: .scale(scale: 0.5).combined(with: .opacity).combined(with: .move(edge: .bottom))
                        ))
                    }
                    .onDelete { offsets in
                        // MARK: - withAnimation example: Animate player deletion in new game view with spring
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            players.remove(atOffsets: offsets)
                        }
                    }
                    .onMove { source, destination in
                        // MARK: - withAnimation example: Animate player reordering in new game view with spring
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            players.move(fromOffsets: source, toOffset: destination)
                        }
                    }
                }
            }
            .navigationTitle("New Game")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { EditButton() }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let game = Game(name: name, inGameSort: inGameSort, winnerRule: winnerRule, players: players)
                        onSave(game)
                        dismiss()
                    }
                }
            }
        }
    }

    private func sortPlayers() {
        switch inGameSort {
        case .highest: players.sort { $0.score > $1.score }
        case .lowest: players.sort { $0.score < $1.score }
        }
    }
}
