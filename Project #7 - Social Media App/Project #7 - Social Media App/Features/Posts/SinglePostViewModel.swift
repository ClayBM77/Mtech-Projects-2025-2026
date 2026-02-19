//
//  SinglePostViewModel.swift
//  Project #7 - Social Media App
//
//  Created by Bridger Mason on 2/13/26.
//

import Foundation

@MainActor
@Observable
final class SinglePostViewModel {
    var post: Post
    private let networkClient: NetworkClientProtocol
    
    var isLiked: Bool = false
    var isDeleting: Bool = false
    var showDeleteConfirmation: Bool = false
    var deleteErrorMessage: String?
    var isLiking: Bool = false
    private var initialLikeCount: Int
    
    init(post: Post, networkClient: NetworkClientProtocol) {
        self.post = post
        self.networkClient = networkClient
        self.initialLikeCount = post.likeCount
        self.isLiked = post.userLiked
    }
    
    func toggleLike(onUpdated: @escaping (Post) -> Void) {
        guard !isLiking else { return }
        isLiking = true
        
        // Preserve the original author - it shouldn't change when liking
        let originalAuthor = post.author
        
        Task {
            do {
                let updatedPost = try await networkClient.likePost(postId: post.id)
                await MainActor.run {
                    // Create updated post with original author preserved
                    let postWithOriginalAuthor = Post(
                        id: updatedPost.id,
                        author: originalAuthor,
                        title: updatedPost.title,
                        body: updatedPost.body,
                        likeCount: updatedPost.likeCount,
                        commentCount: updatedPost.commentCount,
                        createdAt: updatedPost.createdAt,
                        userLiked: updatedPost.userLiked
                    )
                    self.post = postWithOriginalAuthor
                    self.isLiked = updatedPost.userLiked
                    self.isLiking = false
                    onUpdated(postWithOriginalAuthor)
                }
            } catch {
                await MainActor.run {
                    self.isLiking = false
                    // Could show error message here if needed
                }
            }
        }
    }
    
    func deletePost(onDeleted: @escaping () -> Void) {
        deleteErrorMessage = nil
        isDeleting = true
        
        Task {
            do {
                try await networkClient.deletePost(postId: post.id)
                await MainActor.run {
                    isDeleting = false
                    onDeleted()
                }
            } catch {
                await MainActor.run {
                    deleteErrorMessage = "Failed to delete post"
                    isDeleting = false
                }
            }
        }
    }
}

