//
//  Comments.swift
//  Project #7 - Social Media App
//
//  Created by Bridger Mason on 11/18/25.
//

import SwiftUI 

struct CommentsView: View {
    let post: Post
    let networkClient: NetworkClientProtocol
    
    @State private var comments: [Comment] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var likedCommentIDs: Set<String> = []
    
    var body: some View {
        
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading comments...")
                } else if let message = errorMessage {
                    ContentUnavailableView(
                        "Could not load comments",
                        systemImage: "exclamationmark.triangle",
                        description: Text(message)
                    )
                } else if comments.isEmpty {
                    ContentUnavailableView(
                        "No comments yet",
                        systemImage: "text.bubble",
                        description: Text("Be the first to comment!")
                    )
                } else {
                    List(comments) { comment in
                        let isLiked = likedCommentIDs.contains(comment.id)
                        let displayedLikeCount = comment.likeCount + (isLiked ? 1 : 0)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(comment.author.firstName) \(comment.author.lastName) • \(comment.author.userName)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text(comment.body)
                                .font(.body)

                            HStack(spacing: 16) {
                                Button {
                                    if likedCommentIDs.contains(comment.id) {
                                        likedCommentIDs.remove(comment.id)
                                    } else {
                                        likedCommentIDs.insert(comment.id)
                                    }
                                } label: {
                                    Label("\(displayedLikeCount)",
                                          systemImage: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                    .contentShape(Rectangle())
                                    .buttonStyle(.plain)
                                }
                            }
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle("Comments")
        .task {
            await loadComments()
        }
    }
    
    private func loadComments() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await networkClient.fetchComments(postId: post.id)
            comments = fetched
        } catch {
            errorMessage = "Failed to load comments"
        }
        isLoading = false
    }
}
