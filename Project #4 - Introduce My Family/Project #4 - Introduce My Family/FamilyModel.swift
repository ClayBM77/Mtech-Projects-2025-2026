//
//  FamilyModel.swift
//  Project #4 - Introduce My Family
//
//  Created by Bridger Mason on 10/9/25.
//

import Foundation

struct Family: Identifiable {
    let id = UUID()
    var name: String
    var age: String
    var hobby: String
    var weapon: String
    var wasViewed = false
    
    static let familyList: [Family] = [
        Family(name: "Garth", age: "52", hobby: "Mechanics", weapon: ""),
        Family(name: "Cindy", age: "51", hobby: "Calligraphy", weapon: ""),
        Family(name: "Fielden", age: "24", hobby: "Guitar", weapon: ""),
        Family(name: "Bridger", age: "22", hobby: "Pokemon", weapon: "Razorblade Typhoon"),
        Family(name: "Quinlan", age: "19", hobby: "Watching Bluey", weapon: "Sword of Truth"),
        Family(name: "Grant", age: "15", hobby: "Long Boarding", weapon: ""),
        Family(name: "Adison", age: "21", hobby: "Pokemon", weapon: "Sword"),
        Family(name: "Michael", age: "22", hobby: "BYU Football", weapon: "X-Shot Insanity Ragefire"),
        Family(name: "Sally", age: "23", hobby: "Calisthenics", weapon: "Trebuchet")
    
    ]
}


