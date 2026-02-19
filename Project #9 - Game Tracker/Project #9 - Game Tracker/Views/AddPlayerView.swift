//
//  AddPlayerView.swift
//  Project #9 - Game Tracker
//
//  Created by Bridger Mason on 12/11/25.
//


import SwiftUI
import SwiftData

struct AddPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var icon: String = PlayerIcon.dice.rawValue
    var namespace: Namespace.ID
    var onSave: (String, String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Player name", text: $name)
                }
                Section(header: Text("Icon")) {
                    IconPickerView(selectedIcon: $icon, namespace: namespace)
                        .frame(height: 200)
                }
            }
            .navigationTitle("New Player")
            // MARK: - .transition example: Add player view fades in with scale
            .transition(.scale(scale: 0.9).combined(with: .opacity))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmedName.isEmpty else { return }
                        onSave(trimmedName, icon)
                        dismiss()
                    }
                }
            }
        }
    }
}
