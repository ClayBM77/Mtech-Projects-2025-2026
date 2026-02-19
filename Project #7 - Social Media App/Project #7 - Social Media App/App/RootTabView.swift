//
//  ContentView.swift
//  Project #7 - Social Media App
//
//  Created by Bridger Mason on 11/17/25.
//

import SwiftUI

struct RootTabView: View {
    @Environment(APIData.self) private var appServices
    
    var body: some View {
        TabView {
            PostsView(networkClient: appServices.networkClient)
                .tabItem {
                    Label("Posts", systemImage: "rectangle.stack.person.crop")
                }

            ProfileView(
                repository: appServices.userRepository,
                networkClient: appServices.networkClient
            )
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
    }
}

#Preview {
    RootTabView()
}


