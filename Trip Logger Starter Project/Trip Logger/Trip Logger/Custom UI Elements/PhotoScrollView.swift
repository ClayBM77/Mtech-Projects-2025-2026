//
//  PhotoScrollView.swift
//  Trip Logger
//
//  Created by Jane Madsen on 4/29/25.
//


import SwiftUI
import SwiftData
import MapKit
import PhotosUI
import UIKit

struct PhotoScrollView: View {
    var journalEntry: JournalEntry
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImage: Image? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(journalEntry.photos) { photo in
                    if let uiImage = UIImage(data: photo.data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                
                PhotosPicker(
                    selection: $selectedItems,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    VStack(spacing: 12) {
                        Image(systemName: "plus.rectangle.on.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.appOrange)
                        
                        Text("Add Photos...")
                            .font(.caption)
                            .foregroundColor(.appBackground)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: 150, height: 150)
                .background(Color.appBackground.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onChange(of: selectedItems) {
                    loadTransferable()
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    func loadTransferable() {
        for item in selectedItems {
            item.loadTransferable(type: Data.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if let data = data {
                            let newPhoto = Photo(data: data)
                            journalEntry.photos.append(newPhoto)
                        }
                    case .failure(let error):
                        print("Failed to load image: \(error)")
                    }
                }
            }
        }
        selectedItems = []
    }
}
