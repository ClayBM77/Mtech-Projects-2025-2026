//
//  Trip.swift
//  Trip Logger
//
//  Created by Jane Madsen on 4/17/25.
//

import Foundation
import MapKit
import SwiftData

@Model
final class Trip {
    var id: UUID
    var name: String
    var journalEntries: [JournalEntry]
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.journalEntries = []
    }
}

extension Trip {
    static func mock() -> Trip {
        let trip = Trip(name: "France 2025")
  
        let paris = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 48.856788,
                longitude: 2.351077
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.15,
                longitudeDelta: 0.15
            )
        )

        let journalEntry = JournalEntry(name: "Museum", location: Location(region: paris), text: "What a great time we had, oh boy")
        
        trip.journalEntries.append(journalEntry)
        
        return trip
    }
}

extension ModelContainer {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: Trip.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )

        let trip = Trip.mock()
        
        container.mainContext.insert(trip)

        return container
    }
}
