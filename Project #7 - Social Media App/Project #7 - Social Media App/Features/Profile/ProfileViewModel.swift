//
//  ProfileViewModel.swift
//  Project #7 - Social Media App
//
//  Created by Bridger Mason on 11/17/25.
//

import Foundation
import SwiftUI

enum ProfileSaveError: Error {
    case emptyTitle
    case emptyUsername
}

@MainActor
@Observable
final class ProfileViewModel {
    var user: User?
    var errorMessage: String?
    private(set) var currentUserPosts: [Post] = []

    private let repository: UserRepositoryProtocol

    private let networkClient: NetworkClientProtocol

    private(set) var posts: [Post] = []
    private(set) var isLoading: Bool = false

    init(
        networkClient: NetworkClientProtocol,
        repository: UserRepositoryProtocol
    ) {
        self.networkClient = networkClient
        self.repository = repository
    }

    func load() async {
        print("load hit")
        do {
            self.user = try await repository.fetchCurrentUser()
        } catch {
            self.errorMessage = error.localizedDescription
            print(errorMessage as Any)
        }

        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                var allPosts: [Post] = []
                var pageNumber = 0
                var hasMorePages = true
                
                // Fetch all pages until we get an empty result
                while hasMorePages {
                    let pagePosts = try await networkClient.fetchPosts(pageNumber: pageNumber)
                    if pagePosts.isEmpty {
                        hasMorePages = false
                    } else {
                        allPosts.append(contentsOf: pagePosts)
                        pageNumber += 1
                        // If we got less than 10 posts, we've reached the last page
                        if pagePosts.count < 10 {
                            hasMorePages = false
                        }
                    }
                }
                
                self.posts = allPosts

                // All posts by the current user, newest first
                if let currentUser = self.user {
                    self.currentUserPosts =
                        allPosts
                        .filter { $0.author.id == currentUser.id }
                        .sorted(by: { $0.createdAt > $1.createdAt })
                } else {
                    self.currentUserPosts = []
                }
            } catch {
                errorMessage = "Failed to load posts"
            }
        }
    }

    
    func createPost(title: String, body: String) async throws {
        let newPost = try await networkClient.createPost(title: title, body: body)
        
        // Add the new post immediately to the lists
        self.posts.insert(newPost, at: 0)
        self.posts.sort(by: { $0.createdAt > $1.createdAt })
        
        // Add to currentUserPosts if it's by the current user
        if let currentUser = self.user, newPost.author.id == currentUser.id {
            self.currentUserPosts.insert(newPost, at: 0)
            self.currentUserPosts.sort(by: { $0.createdAt > $1.createdAt })
        }
        
        // Reload to ensure we have the latest data (especially for like counts, etc.)
        await load()
    }

    // creates a new post
    func saveNewPost(title: String, body: String) async throws {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBody = body.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            throw ProfileSaveError.emptyTitle
        }

        try await createPost(title: trimmedTitle, body: trimmedBody)
    }

    
    func updateProfile(userName: String, bio: String?, techInterests: String?)
        async throws
    {
        let updated = try await networkClient.updateProfile(
            userName: userName,
            bio: bio,
            techInterests: techInterests
        )
        self.user = updated
    }

    // save profile edits on API
    func saveProfileEdits(userName: String, bio: String, techInterests: String)
        async throws
    {
        let trimmedUserName = userName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard !trimmedUserName.isEmpty else {
            throw ProfileSaveError.emptyUsername
        }

        let trimmedBio = bio.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedInterests = techInterests.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        try await updateProfile(
            userName: trimmedUserName,
            bio: trimmedBio.isEmpty ? nil : trimmedBio,
            techInterests: trimmedInterests.isEmpty ? nil : trimmedInterests
        )
    }

    // Update a post via the API, then update the local post array.
    func updatePost(postId: String, title: String, body: String) async throws {
        let updatedPost = try await networkClient.updatePost(
            postId: postId,
            title: title,
            body: body
        )

        if let index = self.currentUserPosts.firstIndex(where: {
            $0.id == postId
        }) {
            self.currentUserPosts[index] = updatedPost
            self.currentUserPosts.sort(by: { $0.createdAt > $1.createdAt })
        }

        if let index = self.posts.firstIndex(where: { $0.id == postId }) {
            self.posts[index] = updatedPost
        }
    }

    /// Validates and updates a post, then reloads profile data.
    func savePostEdits(postId: String, title: String, body: String) async throws
    {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBody = body.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            throw ProfileSaveError.emptyTitle
        }

        try await updatePost(
            postId: postId,
            title: trimmedTitle,
            body: trimmedBody
        )
    }
    
    func updatePostInLists(_ updatedPost: Post) {
        // Update in currentUserPosts if it exists there
        if let index = currentUserPosts.firstIndex(where: { $0.id == updatedPost.id }) {
            currentUserPosts[index] = updatedPost
            currentUserPosts.sort(by: { $0.createdAt > $1.createdAt })
        }
        // Update in all posts list if it exists there
        if let index = posts.firstIndex(where: { $0.id == updatedPost.id }) {
            posts[index] = updatedPost
        }
    }
}
