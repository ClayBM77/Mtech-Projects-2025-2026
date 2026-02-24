//
//  Comment.swift
//  Project #7 - Social Media App
//
//  Created by Bridger Mason on 11/17/25.
//

import Foundation


struct Comment: Identifiable, Equatable, Sendable, Codable { //comment structure, might need coding keys when accessing web
    
    let id: String
    let postId: String
    let author: User
    let body: String
    let likeCount: Int
    let replyCount: Int
    let createdAt: Date
    
    nonisolated init(id: String, postId: String, author: User, body: String, likeCount: Int, replyCount: Int, createdAt: Date) {
        self.id = id
        self.postId = postId
        self.author = author
        self.body = body
        self.likeCount = likeCount
        self.replyCount = replyCount
        self.createdAt = createdAt
    }
}
