//
//  ContentView.swift
//  InterviewApp
//
//  Created by Bridger Mason on 2/23/26.
//
/*
 Build an app that manages a list of users and allows random selection from that list.
 Requirements

 Allow the user to add any number of people using name only.
 Display all users in a single list.
 Support reordering and deleting items from the list.
 Provide a way for the user to choose how many people should be selected at random.
 Include a button that performs a random selection from the current list.
 Clearly indicate which users were selected.
 Prevent selecting more users than currently exist.
 Persist the list of users and the selection count so the data remains after closing the app.
 Goal
 Focus on building a clear and functional experience that demonstrates:

 Managing dynamic data
 Updating UI based on state changes
 Performing randomized logic
 Maintaining data between launches
 */
 

import SwiftUI
import SwiftData
import Observation

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \User.order) private var storedUsers: [User]

    @State private var viewModel = ContentViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                @Bindable var viewModel = viewModel

                HStack {
                    TextField("Enter name", text: $viewModel.newUser)
                    Button("Add") {
                        viewModel.addUser(modelContext: modelContext, storedUsers: storedUsers)
                    }
                    .disabled(viewModel.newUser.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                Stepper(
                    "Number to select: \(viewModel.selectionCount)",
                    value: $viewModel.selectionCount,
                    in: 1...(viewModel.users.isEmpty ? 1 : viewModel.users.count)
                )
                Button("Select Random Users") {
                    viewModel.selectRandomUsers()
                }
                .disabled(viewModel.users.isEmpty)
                .padding()
                .glassEffect()

                
                Text("Current Users:")
                if viewModel.users.isEmpty {
                    VStack(alignment: .center) {
                        Text("Please create a user")
                            .font(.title)
                            .foregroundColor(.secondary)
                            .padding()
                        Image(systemName: "dog.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.secondary)
                    }
                    
                } else {
                    List {
                        ForEach(viewModel.users.indices, id: \.self) { index in
                            HStack {
                                Text(viewModel.users[index])
                            }
                        }
                        .onDelete { offsets in
                            viewModel.deleteUser(at: offsets, modelContext: modelContext, storedUsers: storedUsers)
                        }
                        .onMove { source, destination in
                            viewModel.moveUsers(from: source, to: destination, modelContext: modelContext, storedUsers: storedUsers)
                        }
                    }
                }
                if !viewModel.selectedUserIndices.isEmpty {
                    Text("Selected Users:")
                }
                List {
                    ForEach(viewModel.users.indices, id: \.self) { index in
                        if viewModel.selectedUserIndices.contains(index) {
                            Text(viewModel.users[index])
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Users")
            .toolbar {
                EditButton()
                    .glassEffect()
            }
        }
        .onAppear {
            viewModel.load(modelContext: modelContext, storedUsers: storedUsers)
        }
        .onChange(of: viewModel.users) { _, newUsers in
            viewModel.adjustCount(for: newUsers.count)
        }
    }
}

#Preview {
    ContentView()
}
