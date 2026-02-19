//___FILEHEADER___

import SwiftUI

@main
struct Project7: App {
    
    @State private var appServices = APIData(
        networkClient: APINetworkClient(authSecret: nil),
        userRepository: MockUserRepository()
    )
    @State private var isLoggedIn = false

    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                RootTabView()
                    .environment(appServices)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
                    .environment(appServices)
            }
        }
    }
}

