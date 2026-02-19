//
//  PostsRowView.swift
//  TSMA
//
//  Created by Nathan Lambson on 11/5/25.
//

import SwiftUI

struct SinglePostView: View {
    @State private var post: Post
    let networkClient: NetworkClientProtocol
    // When non-nil, delete is shown only if this equals the post's author (and only on profile).
    var currentUserID: String? = nil
    var onDeleted: (() -> Void)? = nil
    var onEdit: ((Post) -> Void)? = nil
    var onPostUpdated: ((Post) -> Void)? = nil
    
    @State private var viewModel: SinglePostViewModel
    @State private var showingComments = false

    private var showDeleteButton: Bool {
        guard let currentUserID = currentUserID else { return false }
        return viewModel.post.author.id == currentUserID
    }
    
    private var showEditButton: Bool {
        guard let currentUserID = currentUserID else { return false }
        return viewModel.post.author.id == currentUserID
    }
    
    private var formattedTimeAgo: String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(viewModel.post.createdAt)
        
        let minutes = Int(timeInterval / 60)
        let hours = Int(timeInterval / 3600)
        let days = Int(timeInterval / 86400)
        
        if days > 0 {
            return "\(days) day\(days == 1 ? "" : "s") ago"
        } else if hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else if minutes > 0 {
            return "\(minutes) min ago"
        } else {
            return "just now"
        }
    }
    
    init(
        post: Post,
        networkClient: NetworkClientProtocol,
        currentUserID: String? = nil,
        onDeleted: (() -> Void)? = nil,
        onEdit: ((Post) -> Void)? = nil,
        onPostUpdated: ((Post) -> Void)? = nil
    ) {
        _post = State(initialValue: post)
        self.networkClient = networkClient
        self.currentUserID = currentUserID
        self.onDeleted = onDeleted
        self.onEdit = onEdit
        self.onPostUpdated = onPostUpdated
        _viewModel = State(wrappedValue: SinglePostViewModel(post: post, networkClient: networkClient))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(viewModel.post.author.firstName) \(viewModel.post.author.lastName) - \(viewModel.post.author.userName)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(formattedTimeAgo)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(viewModel.post.title)
                .font(.headline)

            Text(viewModel.post.body)
                .font(.body)

            HStack(spacing: 16) {
                Button {
                    viewModel.toggleLike { updatedPost in
                        post = updatedPost
                        viewModel.post = updatedPost
                        onPostUpdated?(updatedPost)
                    }
                } label: {
                    Label("\(viewModel.post.likeCount)",
                          systemImage: viewModel.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                    .contentShape(Rectangle())
                    .buttonStyle(.plain)
                }
                .disabled(viewModel.isLiking)
                
                Button("\(viewModel.post.commentCount)", systemImage: "text.bubble") {
                    showingComments = true
                }
                .contentShape(Rectangle())
                .buttonStyle(.plain)
                
                if showEditButton || showDeleteButton {
                    Spacer()
                    if showEditButton {
                        Button {
                            onEdit?(viewModel.post)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .buttonStyle(.plain)
                    }
                    if showDeleteButton {
                        Button(role: .destructive) {
                            viewModel.showDeleteConfirmation = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .buttonStyle(.plain)
                        .disabled(viewModel.isDeleting)
                    }
                }
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            
            if let message = viewModel.deleteErrorMessage {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $showingComments) {
            CommentsView(post: viewModel.post, networkClient: networkClient)
                .presentationDetents([.medium, .large])
        }
        .confirmationDialog("Delete Post", isPresented: $viewModel.showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                viewModel.deletePost {
                    onDeleted?()
                }
            }
            Button("Cancel", role: .cancel) {
                viewModel.showDeleteConfirmation = false
            }
        } message: {
            Text("This post will be removed. This cannot be undone.")
        }
    }
}

//#if DEBUG
//extension User {
//    static let sample = User(id: "u_dbg", firstName: "Ada", lastName: "Lovelace", userName: "ada", biography: "Poet of numbers", techInterests: ["Swift","UI"], profileImageURL: nil, coverImageURL: nil)
//}
//extension Post {
//    static let sample = Post(id: "p_dbg", author: .sample, title: "Sample", body: "Preview content", likeCount: 1, commentCount: 0, createdAt: .now)
//}
////#Preview {
////    PostRowView(post: .sample)
////}
//#endif
