//
//  GameDetailView.swift
//  Project #9 - Game Tracker
//
//  Created by Bridger Mason on 12/11/25.
//


import SwiftUI
import SwiftData

struct GameDetailView: View {
    @State var viewModel: GameDetailViewModel
    @State private var showingAddPlayer = false
    @State private var newlyAddedPlayerIcon: String? = nil
    @Namespace private var playerNamespace

    var body: some View {
        List {
            Section(header: Text(viewModel.winnerText)) {
                ForEach(viewModel.game.players, id: \.id) { player in
                    HStack {
                        Image(systemName: player.icon)
                            .font(.title3)
                            .foregroundStyle(.blue)
                            // MARK: - .matchedGeometryEffect example: Player icon/name smoothly moves when reordering
                            .matchedGeometryEffect(id: "player-\(player.id)", in: playerNamespace)
                            // MARK: - .matchedGeometryEffect example: New player icon animates from picker to list position
                            .if(newlyAddedPlayerIcon == player.icon) { view in
                                view.matchedGeometryEffect(id: "newPlayerIcon", in: playerNamespace, isSource: false)
                            }
                        Text(player.name)
                            // MARK: - .matchedGeometryEffect example: Player name moves smoothly when reordering
                            .matchedGeometryEffect(id: "playerName-\(player.id)", in: playerNamespace)
                        Spacer()
                        Stepper(value: Binding(
                            get: { player.score },
                            set: { newValue in
                                // MARK: - withAnimation example: Animate player reordering when score changes with more visible spring
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.3)) {
                                    player.score = newValue
                                    viewModel.sortPlayers()
                                }
                            }
                        ), in: 0...999) {
                            Text("\(player.score)")
                                .monospacedDigit()
                        }
                    }
                    // MARK: - .transition example: Player items fade and slide when added/removed with scale
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity).combined(with: .scale(scale: 0.8)),
                        removal: .move(edge: .trailing).combined(with: .opacity).combined(with: .scale(scale: 0.8))
                    ))
                }
                .onDelete { indexSet in
                    // MARK: - withAnimation example: Animate player deletion with spring
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                        viewModel.deletePlayers(at: indexSet)
                    }
                }
                .onMove { source, destination in
                    // MARK: - withAnimation example: Animate player manual reordering with spring
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        viewModel.movePlayers(from: source, to: destination)
                    }
                }
            }
        }
        .navigationTitle(viewModel.game.name)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { EditButton() }
            ToolbarItem(placement: .topBarTrailing) {
                Button { showingAddPlayer = true } label: { Image(systemName: "plus") }
            }
        }
        .sheet(isPresented: $showingAddPlayer) {
            AddPlayerView(namespace: playerNamespace) { name, icon in
                // MARK: - withAnimation example: Animate new player appearing in list with bounce
                newlyAddedPlayerIcon = icon
                withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
                    viewModel.addPlayer(named: name, icon: icon)
                }
                // Clear the newly added icon after animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    newlyAddedPlayerIcon = nil
                }
                showingAddPlayer = false
            }
            // MARK: - .transition example: Add player sheet slides up with scale
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}
/*
#Preview("Game Detail") {
    // Build an in-memory SwiftData container for previews
    func makePreviewContainer() -> ModelContainer {
        let schema = Schema([Game.self, Player.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: config)

        // Seed sample data
        let samplePlayers = [
            Player(name: "Alex", score: 12),
            Player(name: "Sam", score: 8),
            Player(name: "Jordan", score: 15)
        ]
        let sampleGame = Game(name: "Catan", players: samplePlayers)
        container.mainContext.insert(sampleGame)
        return container
    }

    let container = makePreviewContainer()
    let sampleGame = try! container.mainContext.fetch(FetchDescriptor<Game>()).first!
    let vm = GameDetailViewModel(game: sampleGame, context: container.mainContext)

    NavigationStack {
        GameDetailView(viewModel: vm)
    }
    .modelContainer(container)
}
*/
