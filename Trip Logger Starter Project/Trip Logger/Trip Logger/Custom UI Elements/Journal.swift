//
//  Journal.swift
//  Trip Logger
//
//  Created by Jane Madsen on 4/29/25.
//


import SwiftUI
import SwiftData
import MapKit
import PhotosUI

struct Journal: View {
    @Binding var journalEntry: JournalEntry?
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            JournalTopBar(journalEntry: $journalEntry)
                .padding(.horizontal, 20)
                .padding(.top, 16)
            
            if let journalEntry {
                VStack(alignment: .leading, spacing: 12) {
                    Text(journalEntry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)
                        .foregroundColor(.appBackground)
                        .padding(.horizontal, 20)
                    
                    if !journalEntry.text.isEmpty {
                        Text(journalEntry.text)
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                    }
                    
                    if !journalEntry.photos.isEmpty {
                        PhotoScrollView(journalEntry: journalEntry)
                    }
                }
            }
        }
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}



struct JournalTopBar: View {
    @Binding var journalEntry: JournalEntry?
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            Button("Edit") {
                if journalEntry != nil {
                    isEditing = true
                }
            }
            .foregroundColor(.appOrange)
            
            Spacer()
            
            Text(journalEntry?.name ?? "Journal")
                .font(.title)
                .foregroundColor(.black)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button("Dismiss") {
                journalEntry = nil
            }
            .foregroundColor(.appDarkOrange)
        }
        .sheet(isPresented: $isEditing) {
            if let entry = journalEntry {
                NavigationStack {
                    SetUpPinScreen(journalEntry: entry)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var trip = Trip.mock()
    
    TripMapScreen(trip: trip, position: .automatic, selectedEntry: trip.journalEntries.first)
}
