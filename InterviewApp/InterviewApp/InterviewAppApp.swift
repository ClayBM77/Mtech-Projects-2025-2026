//
//  InterviewAppApp.swift
//  InterviewApp
//
//  Created by Bridger Mason on 2/23/26.
//

import SwiftUI
import SwiftData

@main
struct InterviewAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
