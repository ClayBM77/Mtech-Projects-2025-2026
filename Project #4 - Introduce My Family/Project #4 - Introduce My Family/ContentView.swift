//
//  ContentView.swift
//  Project #4 - Introduce My Family
//
//  Created by Bridger Mason on 10/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var path: [String] = []

    @State private var familyList = Family.familyList
    @State private var selectedFamily: Family? = nil
    var body: some View {
        NavigationStack(path: $path) {
            List($familyList) { $family in
                Button {
                    family.wasViewed = true
                    selectedFamily = family

                } label: {
                    HStack {
                        Image(family.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text(family.name)
                            .foregroundStyle(.black)
                        Text("✅")
                            .opacity(family.wasViewed ? 1 : 0)
                    }
                }

            }
            .sheet(item: $selectedFamily) { family in
                if let currentIndex = familyList.firstIndex(where: { $0.id == family.id }) {
                    InformationView(family: familyList[currentIndex])
                }
            }
            .navigationTitle("The Squad")
        }
    }
}

#Preview {
    ContentView()
}
