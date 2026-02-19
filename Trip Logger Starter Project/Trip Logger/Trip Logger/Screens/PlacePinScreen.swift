//
//  PlacePinScreen.swift
//  Trip Logger
//
//  Created by Jane Madsen on 4/29/25.
//


import SwiftUI
import SwiftData
import MapKit
import PhotosUI

struct PlacePinScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var trip: Trip
    @Binding var isPresented: Bool
    
    
    private var journalEntry: JournalEntry? {
        trip.journalEntries.first
    }
    
    var body: some View {
        VStack {
            MapReader { reader in
                Map {
                    if let journalEntry, let coordinate = journalEntry.location.coordinate {
                        Marker("", coordinate: coordinate)
                            .tint(Color.appOrange)
                    }
                }
                .simultaneousGesture(
                    SpatialTapGesture()
                        .onEnded { value in
                            placePin(reader: reader, location: value.location)
                        }
                )
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Place First Pin")
        .toolbar {
            NavigationLink("Next") {
                if let journalEntry {
                    SetUpPinScreen(journalEntry: journalEntry, isPresented: $isPresented)
                }
            }
            .disabled(journalEntry == nil)
            .foregroundColor(.appOrange)
        }
    }
    
    func placePin(reader: MapProxy, location: CGPoint) {
        guard let coordinate = reader.convert(location, from: .local) else { return }
        
        
        if let existingEntry = trip.journalEntries.first {
            trip.journalEntries.removeAll()
            modelContext.delete(existingEntry)
        }
        
        
        let entry = JournalEntry(location: Location(latitude: coordinate.latitude, longitude: coordinate.longitude))
        
        trip.journalEntries.append(entry)
        modelContext.insert(entry)
        
        // reverseGeocode(coordinate: coordinate, entry: entry)
        
        try? modelContext.save()
    }
    
    // MARK: - Reverse Geocoding (Commented out)
    /*
    func reverseGeocode(coordinate: CLLocationCoordinate2D, entry: JournalEntry) {
        // Search for nearby named places to get location information
        searchNearbyPlaces(coordinate: coordinate, entry: entry)
    }
    
    func searchNearbyPlaces(coordinate: CLLocationCoordinate2D, entry: JournalEntry) {
        let request = MKLocalSearch.Request()
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        request.region = region
        
        // Search for nearby places - try to find any named location
        request.naturalLanguageQuery = "location"
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            Task { @MainActor in
                // Look through results for a named place (skip generic terms)
                let genericTerms = ["location", "point of interest", "landmark"]
                
                if let mapItems = response?.mapItems {
                    for mapItem in mapItems {
                        // Prefer items with actual names that aren't generic
                        if let name = mapItem.name, 
                           !name.isEmpty,
                           !genericTerms.contains(where: { name.lowercased().contains($0) }) {
                            entry.name = name
                            try? self.modelContext.save()
                            return
                        }
                    }
                    
                    // If no good name found, use address from first result
                    if let firstItem = mapItems.first,
                       let address = firstItem.address {
                        let locationName = address.shortAddress ?? address.fullAddress ?? ""
                        if !locationName.isEmpty {
                            entry.name = locationName
                            try? self.modelContext.save()
                            return
                        }
                    }
                }
                
                // Final fallback
                entry.name = "Unknown Location"
                try? self.modelContext.save()
            }
        }
    }
    */
}

//#Preview {
//    NavigationStack {
//        PlacePinScreen(trip: Trip.mock())
//    }
//    .modelContainer(ModelContainer.preview)
//}
