//
//  GamesListView.swift
//  Project #9 - Game Tracker
//
//  Created by Bridger Mason on 12/11/25.
//


import SwiftUI
import SwiftData

struct GamesListView: View {
    let viewModel: GamesListViewModel
    @State private var showingNewGame = false
    @Namespace private var gameNamespace
    
    @Query(sort: \Game.createdAt, order: .reverse) var games: [Game]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                if games.isEmpty {
                    Text("No games yet. Tap + to add one.")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        // MARK: - .transition example: Empty state fade in
                        .transition(.opacity)
                }
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(game.name)
                                    .font(.headline)
                                    // MARK: - .matchedGeometryEffect example: Game name shared between list and detail
                                    .matchedGeometryEffect(id: "gameName-\(game.id)", in: gameNamespace)
                                Text(GameSummaryFormatter.summary(for: game))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(viewModelText(for: game))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        // MARK: - .transition example: Game items slide in from trailing edge with scale
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity).combined(with: .scale(scale: 0.8)),
                            removal: .move(edge: .leading).combined(with: .opacity).combined(with: .scale(scale: 0.8))
                        ))
                    }
                }
                .onDelete { indexSet in
                    // MARK: - withAnimation example: Animate game deletion with bounce
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                        viewModel.delete(games: games, at: indexSet, using: modelContext)
                    }
                }
                .onMove { source, destination in
                    // MARK: - withAnimation example: Animate game reordering with spring
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        var snapshot = games
                        viewModel.move(games: &snapshot, from: source, to: destination, using: modelContext)
                    }
                }
            }
            .navigationTitle("Games")
            .navigationDestination(for: Game.self) { game in
                GameDetailView(viewModel: GameDetailViewModel(game: game))
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { EditButton() }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingNewGame = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showingNewGame) {
                NewGameView { newGame in
                    // MARK: - withAnimation example: Animate new game appearing in list with bounce
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        viewModel.add(game: newGame, using: modelContext)
                    }
                    showingNewGame = false
                }
                // MARK: - .transition example: Sheet slides up from bottom with scale
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

    private func viewModelText(for game: Game) -> String {
        switch game.winnerRule {
        case .highest: return "High wins"
        case .lowest: return "Low wins"
        }
    }
}

enum GameSummaryFormatter {
    static func summary(for game: Game) -> String {
        if game.players.isEmpty { return "No players yet" }
        let sorted = game.players.sorted { a, b in
            switch game.inGameSort {
            case .highest: return a.score > b.score
            case .lowest: return a.score < b.score
            }
        }
        if let top = sorted.first { return "\(top.name): \(top.score)" }
        return "No players yet"
    }
}
