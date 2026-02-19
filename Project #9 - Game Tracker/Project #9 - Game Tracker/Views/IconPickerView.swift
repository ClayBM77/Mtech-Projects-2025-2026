//
//  IconPickerView.swift
//  Project #9 - Game Tracker
//
//  Created by Bridger Mason on 12/11/25.
//

import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    var namespace: Namespace.ID?
    let columns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(PlayerIcon.allCases) { playerIcon in
                    Button {
                        selectedIcon = playerIcon.rawValue
                    } label: {
                        Image(systemName: playerIcon.rawValue)
                            .font(.title2)
                            .foregroundStyle(selectedIcon == playerIcon.rawValue ? .blue : .primary)
                            .frame(width: 50, height: 50)
                            .background(
                                Circle()
                                    .fill(selectedIcon == playerIcon.rawValue ? Color.accentColor.opacity(0.2) : Color.clear)
                            )
                            .overlay(
                                Circle()
                                    .stroke(selectedIcon == playerIcon.rawValue ? Color.accentColor : Color.clear, lineWidth: 3)
                            )
                            .scaleEffect(selectedIcon == playerIcon.rawValue ? 1.1 : 1.0)
                            // MARK: - .matchedGeometryEffect example: Selected icon animates from picker to player list
                            .if(selectedIcon == playerIcon.rawValue && namespace != nil) { view in
                                view.matchedGeometryEffect(id: "newPlayerIcon", in: namespace!)
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}


extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


