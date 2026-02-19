//
//  TimelineViewModel.swift
//  TSMA
//
//  Created by Nathan Lambson on 11/5/25.
//

import Foundation

@Observable
final class PostsViewModel {
    private(set) var posts: [Post] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?

    private let networkClient: NetworkClientProtocol 

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func load() {
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
                
                posts = allPosts.sorted(by: { $0.createdAt > $1.createdAt })
            } catch {
                errorMessage = "Failed to load posts"
            }
        }
    }
    
    func updatePost(_ updatedPost: Post) {
        if let index = posts.firstIndex(where: { $0.id == updatedPost.id }) {
            posts[index] = updatedPost
        }
    }
}
