//
//  ContentiewModel.swift
//  InterviewApp
//
//  Created by Bridger Mason on 2/23/26.
//
import Foundation
import SwiftData

@Model
class User {
    var id: String
    var name: String
    var order: Int
    
    init(id: String = UUID().uuidString, name: String, order: Int) {
        self.id = id
        self.name = name
        self.order = order
    }
}
