//
//  ContentView.swift
//  Project #9 - Game Tracker
//
//  Created by Bridger Mason on 12/11/25.
//


import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        GamesListView(viewModel: GamesListViewModel(context: context))
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, Player.self, configurations: config)
    return ContentView()
        .modelContainer(container)
}
