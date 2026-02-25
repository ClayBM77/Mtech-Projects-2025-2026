//
//  ContentView.swift
//  InterviewApp2
//
//  Created by Bridger Mason on 2/25/26.
//
/*
 This code challenge is meant to show off your skills in networking (UIKit or SwiftUI). Your task is to create an app using this API https://randomuser.me
 Your app should have two screens. One screen with settings on how many users to display and what type of information would be displayed such as gender, location, email, login, registered, dob, phone, cell, id, and nat. For this project name and picture are always required.
 The second screen should show a tableview with all of the users and the information that has been selected with their name and photo.
 A nice color scheme and UX would be appreciated.
 */

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
