//
//  Post.swift
//  TSMA
//
//  Created by Nathan Lambson on 11/5/25.
//

import Foundation

struct Post: Identifiable, Equatable, Sendable, Codable {
    let id: String
    let author: User
    let title: String
    let body: String
    let likeCount: Int
    let commentCount: Int
    let createdAt: Date
    let userLiked: Bool
    
    init(id: String, author: User, title: String, body: String, likeCount: Int, commentCount: Int, createdAt: Date, userLiked: Bool = false) {
        self.id = id
        self.author = author
        self.title = title
        self.body = body
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.createdAt = createdAt
        self.userLiked = userLiked
    }
}
