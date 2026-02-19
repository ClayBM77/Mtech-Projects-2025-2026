import SwiftUI

struct ContentView: View {
    private let dogAPI: DogAPIControllerProtocol = DogAPIController()
    private let repAPI: RepresentativeAPIControllerProtocol = RepresentativeAPIController()

    var body: some View {
        TabView {
            DogsView(api: dogAPI)
                .tabItem {
                    Label("Dogs", systemImage: "pawprint")
                }

            RepresentativesView(api: repAPI)
                .tabItem {
                    Label("Representatives", systemImage: "person.2")
                }
        }
    }
}

#Preview {
    ContentView()
}
