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

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \User.order) private var storedUsers: [User]

    @State private var users: [String] = []
    @State private var newUser: String = ""
    @State private var selectedUserIndices: Set<Int> = []
    @AppStorage("selectionCount") private var selectionCount: Int = 1
    @AppStorage("selectedUserIndices") private var selectedUserIndicesStorage: String = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    TextField("Enter name", text: $newUser)
                    Button("Add") {
                        addUser()
                    }
                    .disabled(newUser.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                Stepper(
                    "Number to select: \(selectionCount)",
                    value: $selectionCount,
                    in: 1...(users.isEmpty ? 1 : users.count)
                )
                Button("Select Random Users") {
                    selectRandomUsers()
                }
                .disabled(users.isEmpty)
                .padding()
                .glassEffect()

                List {
                    ForEach(users.indices, id: \.self) { index in
                        HStack {
                            Text(users[index])
                        }
                    }
                    .onDelete(perform: deleteUsers)
                    .onMove(perform: moveUsers)
                }
                if !selectedUserIndices.isEmpty {
                    Text("Selected Users:")
                }
                List {
                    ForEach(users.indices, id: \.self) { index in
                        if selectedUserIndices.contains(index) {
                            Text(users[index])
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
            load()
        }
        .onChange(of: users) { _, newUsers in
            adjustCount(for: newUsers.count)
        }
    }

    private func addUser() {
        let formattedName = newUser.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !formattedName.isEmpty else { return }

        users.append(formattedName)
        newUser = ""
        selectedUserIndices.removeAll()
        save()
        saveSelectedUserIndices()
    }

    private func deleteUsers(at offsets: IndexSet) {
        users.remove(atOffsets: offsets)
        selectedUserIndices.removeAll()
        save()
        saveSelectedUserIndices()
    }

    private func moveUsers(from source: IndexSet, to destination: Int) {
        var newOrder = users
        newOrder.move(fromOffsets: source, toOffset: destination)
        users = newOrder
        selectedUserIndices.removeAll()
        save()
        //saveSelectedUserIndices()
    }

    private func selectRandomUsers() {
        let allUserIndices = Array(users.indices)

        selectedUserIndices = Set(allUserIndices.shuffled().prefix(selectionCount))
        saveSelectedUserIndices()
    }

    private func adjustCount(for userCount: Int) {
        if userCount == 0 {
            selectionCount = 1
        } else if selectionCount > userCount {
            selectionCount = userCount
        }
    }

    private func load() {
        // load users
        users = storedUsers
            .sorted(by: { $0.order < $1.order })
            .map { $0.name }

        //load last random set
        let indices = selectedUserIndicesStorage
            .split(separator: ",")
            .compactMap { Int($0) }
            .filter { $0 >= 0 && $0 < users.count }

        selectedUserIndices = Set(indices)
    }

    private func save() {
        for user in storedUsers {
            modelContext.delete(user)
        }

        for (index, name) in users.enumerated() {
            let user = User(name: name, order: index)
            modelContext.insert(user)
        }

        try? modelContext.save()
    }

    private func saveSelectedUserIndices() {
        let indicesString = selectedUserIndices
            .sorted()
            .map(String.init)
            .joined(separator: ",")

        selectedUserIndicesStorage = indicesString
    }
}

#Preview {
    ContentView()
}
