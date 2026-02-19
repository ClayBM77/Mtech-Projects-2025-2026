//
//  SetUpPinScreen.swift
//  Trip Logger
//
//  Created by Jane Madsen on 4/29/25.
//


import SwiftUI
import SwiftData
import MapKit
import PhotosUI

struct SetUpPinScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var journalEntry: JournalEntry
    var isPresented: Binding<Bool>?
    
    private var trip: Trip? {
        journalEntry.trip
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(.subheadline)
                        .foregroundColor(.appCardBackground)
                    TextField("Enter pin name", text: $journalEntry.name)
                        .textFieldStyle(.themed)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.subheadline)
                        .foregroundColor(.appCardBackground)
                    TextField("Add notes about this stop", text: $journalEntry.text, axis: .vertical)
                        .textFieldStyle(.themed)
                        .lineLimit(5...10)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Photos")
                        .font(.subheadline)
                        .foregroundColor(.appCardBackground)
                    PhotoScrollView(journalEntry: journalEntry)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
        }
        .background(Color.appBackground)
        .navigationTitle("Set Up Pin")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if let trip = trip, let isPresented = isPresented {
                    NavigationLink("Add Another Pin") {
                        PlacePinScreen(trip: trip, isPresented: isPresented)
                    }
                    .disabled(true) // Feature not implemented
                    .foregroundColor(.appOrange)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    dismissToRoot()
                }
                .foregroundColor(.appOrange)
            }
        }
    }
    
    func dismissToRoot() {
        try? modelContext.save()
        
        if let isPresented = isPresented {
            isPresented.wrappedValue = false
        } else {
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        SetUpPinScreen(journalEntry: JournalEntry(), isPresented: nil)
    }
    .modelContainer(ModelContainer.preview)
}
