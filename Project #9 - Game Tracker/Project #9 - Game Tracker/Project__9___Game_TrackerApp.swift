import SwiftUI
import SwiftData

@main
struct Project__9___Game_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Game.self, Player.self])
    }
}
