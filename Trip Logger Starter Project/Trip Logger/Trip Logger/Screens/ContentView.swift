//
//  ContentView.swift
//  Trip Logger
//
//  Created by Jane Madsen on 4/16/25.
//

import SwiftUI
import SwiftData
import MapKit
import PhotosUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var trips: [Trip]
        
    @State var isShowingNewTrip = false
    @State private var newTrip: Trip?
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            ViewThatFits {
                if trips.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "map")
                            .font(.system(size: 60))
                            .foregroundColor(.appOrange)
                        Text("No trips yet.")
                            .font(.title3)
                            .foregroundColor(.appCream)
                        Text("Tap Add to create your first trip")
                            .font(.subheadline)
                            .foregroundColor(.appCardBackground)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.appBackground)
                } else {
                    List {
                        ForEach(trips) { trip in
                            NavigationLink(
                                destination: TripMapScreen(
                                    trip: trip,
                                    position: .automatic
                                )
                            ) {
                                Text(trip.name)
                                    .font(.body)
                                    .foregroundColor(.black)
                            }
                            .listRowBackground(Color.appCardBackground.opacity(0.6))
                        }
                        .onDelete(perform: deleteTrips)
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(Color.appBackground)
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Trip Logger")
            .toolbar {
                Button("Add") {
                    let trip = Trip(name: "")
                    newTrip = trip
                    modelContext.insert(trip)
                    isShowingNewTrip = true
                }
                .foregroundColor(.appOrange)
            }
            .sheet(isPresented: $isShowingNewTrip) {
                Group {
                    if let newTrip = newTrip {
                        NewTripScreen(newTrip: newTrip, isPresented: $isShowingNewTrip)
                    } else if showError {
                        ProgressView()
                    }
                }
                .task {
                    
                    showError = false
                    
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    if newTrip == nil {
                        showError = true
                    }
                }
                .onChange(of: isShowingNewTrip) { oldValue, newValue in
                    
                    if !newValue {
                        showError = false
                    }
                }
            }
        }
    }
    
    private func deleteTrips(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(trips[index])
            }
            try? modelContext.save()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelContainer.preview)
}
