import Foundation
import Observation
import SwiftData
import SwiftUI

@Observable
class ContentViewModel {
    var users: [String] = []
    var newUser: String = ""
    var selectedUserIndices: Set<Int> = []
    var selectionCount: Int = 1
    private let selectedUserIndicesKey = "selectedUserIndices"

    func addUser(modelContext: ModelContext, storedUsers: [User]) {
        let formattedName = newUser.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !formattedName.isEmpty else { return }

        users.append(formattedName)
        newUser = ""
        selectedUserIndices.removeAll()
        save(modelContext: modelContext, storedUsers: storedUsers)
        saveSelectedUserIndices()
    }

    func deleteUser(at offsets: IndexSet, modelContext: ModelContext, storedUsers: [User]) {
        users.remove(atOffsets: offsets)
        selectedUserIndices.removeAll()
        save(modelContext: modelContext, storedUsers: storedUsers)
        saveSelectedUserIndices()
    }

    func moveUsers(from source: IndexSet, to destination: Int, modelContext: ModelContext, storedUsers: [User]) {
        var newOrder = users
        newOrder.move(fromOffsets: source, toOffset: destination)
        users = newOrder
        selectedUserIndices.removeAll()
        save(modelContext: modelContext, storedUsers: storedUsers)
    }

    func selectRandomUsers() {
        let allUserIndices = Array(users.indices)

        selectedUserIndices = Set(allUserIndices.shuffled().prefix(selectionCount))
        saveSelectedUserIndices()
    }

    func adjustCount(for userCount: Int) {
        if userCount == 0 {
            selectionCount = 1
        } else if selectionCount > userCount {
            selectionCount = userCount
        }
        UserDefaults.standard.set(selectionCount, forKey: "selectionCount")
    }

    func load(modelContext: ModelContext, storedUsers: [User]) {
        
        //load users
        users = storedUsers
            .sorted(by: { $0.order < $1.order })
            .map { $0.name }

//        if users.isEmpty {
//            users = ["Bob", "Riley", "Jimbo"]
//            save(modelContext: modelContext, storedUsers: storedUsers)
//        }

        //load selection count
        let storedSelectionCount = UserDefaults.standard.integer(forKey: "selectionCount")
        selectionCount = storedSelectionCount == 0 ? 1 : storedSelectionCount

        //load current indices
        let indices = UserDefaults.standard
            .string(forKey: selectedUserIndicesKey)?
            .split(separator: ",")
            .compactMap { Int($0) }
            .filter { $0 >= 0 && $0 < users.count } ?? []

        selectedUserIndices = Set(indices)
    }

    private func save(modelContext: ModelContext, storedUsers: [User]) {
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

        UserDefaults.standard.set(indicesString, forKey: selectedUserIndicesKey)
    }
}

