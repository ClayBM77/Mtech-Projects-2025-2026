//
//  User.swift
//  TSMA
//
//  Created by Nathan Lambson on 11/5/25.
//

import Foundation

struct User: Identifiable, Equatable, Sendable, Codable {
    let id: String
    let firstName: String
    let lastName: String
    let userName: String
    let biography: String
    let techInterests: [String]
    let profileImageURL: URL?
    let coverImageURL: URL?
    
    nonisolated init(id: String, firstName: String, lastName: String, userName: String, biography: String, techInterests: [String], profileImageURL: URL? = nil, coverImageURL: URL? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.biography = biography
        self.techInterests = techInterests
        self.profileImageURL = profileImageURL
        self.coverImageURL = coverImageURL
    }
}
