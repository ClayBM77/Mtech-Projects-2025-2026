//
//  TripMapScreen.swift
//  Trip Logger
//
//  Created by Jane Madsen on 4/29/25.
//


import SwiftUI
import SwiftData
import MapKit
import PhotosUI

struct TripMapScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var trip: Trip
    
    @State var position: MapCameraPosition
    @State var selectedEntry: JournalEntry?
    @State var isEditingTrip = false
    @State var isPlacingPin = false
    @State var isEditingName = false
    @State var newPinEntry: JournalEntry?
    
    var body: some View {
        VStack {
            MapReader { reader in
                Map(position: $position, selection: $selectedEntry) {
                    ForEach(trip.journalEntries) { journalEntry in
                        Marker("\(journalEntry.name)", coordinate: journalEntry.location.coordinate!)
                            .tag(journalEntry)
                            .tint(Color.appOrange)
                    }
                }
                .mapStyle(.standard)
                .simultaneousGesture(
                    SpatialTapGesture()
                        .onEnded { value in
                            if isPlacingPin {
                                if let coordinate = reader.convert(value.location, from: .local) {
                                    placeNewPin(coordinate: coordinate)
                                }
                            }
                        }
                )
            }
            
            if selectedEntry != nil {
                Journal(journalEntry: $selectedEntry)
            }
            
        }
        .navigationTitle(trip.name)
        .tint(Color.black)
        .sheet(item: $newPinEntry) { entry in
            NavigationStack {
                SetUpPinScreen(journalEntry: entry)
            }
        }
        .background(Color.appBackground)
        .toolbar {
            Button(isPlacingPin ? "Done" : "Edit") {
                if isPlacingPin {
                    isPlacingPin = false
                } else {
                    showEditOptions()
                }
            }
            .foregroundColor(.appOrange)
        }
        .confirmationDialog("Edit Trip", isPresented: $isEditingTrip) {
            Button("Edit Name") {
                isEditingName = true
            }
            Button("Add Pin", role: .none) {
                isPlacingPin = true
            }
            Button("Delete Trip", role: .destructive) {
                deleteTrip()
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $isEditingName) {
            NavigationStack {
                VStack(spacing: 24) {
                    Text("Edit Trip Name")
                        .font(.headline)
                        .foregroundColor(.appCream)
                        .padding(.top, 20)
                    
                    TextField("Trip Name", text: $trip.name)
                        .textFieldStyle(.themed)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .background(Color.appBackground)
                .navigationTitle("Edit Trip")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            try? modelContext.save()
                            isEditingName = false
                        }
                        .foregroundColor(.appOrange)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            isEditingName = false
                        }
                        .foregroundColor(.appDarkOrange)
                    }
                }
            }
        }
    }
    
    func showEditOptions() {
        isEditingTrip = true
    }
    
    func placeNewPin(coordinate: CLLocationCoordinate2D) {
        let entry = JournalEntry(location: Location(latitude: coordinate.latitude, longitude: coordinate.longitude))
        trip.journalEntries.append(entry)
        modelContext.insert(entry)
        try? modelContext.save()
        isPlacingPin = false
        newPinEntry = entry
    }
    
    func deleteTrip() {
        modelContext.delete(trip)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    NavigationStack {
        TripMapScreen(trip: Trip.mock(), position: .automatic)
    }
}
