//
//  NewTripView.swift
//  Trip Logger
//
//  Created by Jane Madsen on 4/29/25.
//

import SwiftUI
import SwiftData
import MapKit
import PhotosUI

struct NewTripScreen: View {
    @Bindable var newTrip: Trip
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("First, give a name to your trip.")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appCream)
                
                TextField("Enter Name Here", text: $newTrip.name)
                    .textFieldStyle(.themed)
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.appBackground)
            .toolbar {
                NavigationLink("Next") {
                    PlacePinScreen(trip: newTrip, isPresented: $isPresented)
                }
                .disabled(newTrip.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .foregroundColor(.appOrange)
            }
        }
    }
}

//#Preview {
//    NewTripScreen()
//        .modelContainer(ModelContainer.preview)
//}
