//
//  TextListView.swift
//  SwiftUI-Intro
//
//  Created by Bridger Mason on 9/23/25.
//

import SwiftUI

struct TextListView: View {
    var string = "YOLO"
    var body: some View {
        Text("Hello, my guy!")
        
        Text("Hey")
        
        Text(string)
            .foregroundStyle(.red)
            .font(.custom("Zapfino", size: 75))
            .italic()
            .onAppear {
                print(UIFont.familyNames)
            }
    }
}

#Preview {
    TextListView()
}
