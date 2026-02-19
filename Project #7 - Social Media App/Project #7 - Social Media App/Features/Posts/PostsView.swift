//
//  TimelineView.swift
//  TSMA
//
//  Created by Nathan Lambson on 11/5/25.
//

import SwiftUI

struct PostsView: View {
    @State private var viewModel: PostsViewModel
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self._viewModel = State(wrappedValue: PostsViewModel(networkClient: networkClient))
        self.networkClient = networkClient
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading posts")
                } else if let message = viewModel.errorMessage {
                    ContentUnavailableView("Could not load posts", systemImage: "exclamationmark.triangle", description: Text(message))
                } else {
                    List(viewModel.posts) { post in
                        SinglePostView(
                            post: post,
                            networkClient: networkClient,
                            onPostUpdated: { updatedPost in
                                // Update the post in the list
                                viewModel.updatePost(updatedPost)
                            }
                        )
                    }
                    .listStyle(.plain)
                    .refreshable(action: viewModel.load)
                }
            }
            .navigationTitle("Posts")
        }
        .task {
            viewModel.load()
        }
    }
}
