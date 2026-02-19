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
}
