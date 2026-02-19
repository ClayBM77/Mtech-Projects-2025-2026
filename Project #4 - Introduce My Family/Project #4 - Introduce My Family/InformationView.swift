//
//  Information.swift
//  Project #4 - Introduce My Family
//
//  Created by Bridger Mason on 10/9/25.
//

import SwiftUI

struct InformationView: View {
    let family: Family
    
    var body: some View {
        Form {
            Section("Information for \(family.name)") {
                
                Text("Age: \(family.age)")
                Text("Hobby: \(family.hobby)")
                Text("Weapon Of Choice: \(family.weapon)")
                
            }
        }
    }
    
}

