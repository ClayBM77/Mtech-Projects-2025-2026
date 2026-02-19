//
//  ProfileView.swift
//  TSMA
//
//  Created by Nathan Lambson on 11/5/25.
//

/*
A **user profile page** tab.
    - This screen should show the **currently logged in user**.
    - It should show a **profile photo** and a **background (cover) photo** at the top of the screen.
    - It should show the user's **first name, last name, username, bio, and tech interests**. Since this app is designed for Tech Industry workers, the tech interests is a place for them to specifically list the topics that they are interested in.
    - It should have **at least one post** (representing the most recent user post) under the user details.
*/

import SwiftUI

struct ProfileView: View {

    @State private var viewModel: ProfileViewModel
    private let networkClient: NetworkClientProtocol
    @State private var isShowingEditProfile = false
    @State private var isShowingNewPostSheet = false
    @State private var isShowingEditPostSheet = false
    @State private var editingPost: Post?

    @State private var draftTitle: String = ""
    @State private var draftBody: String = ""
    @State private var isSavingPost: Bool = false
    @State private var postErrorMessage: String?

    @State private var editUserName: String = ""
    @State private var editBio: String = ""
    @State private var editTechInterests: String = ""
    @State private var isSavingProfile: Bool = false
    @State private var profileErrorMessage: String?

    init(
        repository: UserRepositoryProtocol = MockUserRepository(),
        networkClient: NetworkClientProtocol = MockNetworkClient()
    ) {
        self.networkClient = networkClient
        _viewModel = State(
            wrappedValue: ProfileViewModel(
                networkClient: networkClient,
                repository: repository
            )
        )
    }

    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .bottom) {
                    //                    if let url = viewModel.user?.coverImageURL {
                    //                        AsyncImage(url: url) { image in
                    //                            image
                    //                                .resizable()
                    //                                .scaledToFill()
                    //                        } placeholder: {
                    //                            Color.gray.opacity(0.2)
                    //                        }
                    //                        .frame(maxWidth: .infinity, maxHeight: 180)
                    //                        .clipped()
                    //                        .ignoresSafeArea(.all)
                    //                    } else {
                    //                        // Fallback if no URL yet
                    //                        Color.gray.opacity(0.2)
                    //                            .frame(maxWidth: .infinity, maxHeight: 160)
                    //                    }

                    HStack(alignment: .center) {

                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.white, lineWidth: 3))
                            .shadow(radius: 6)
                            .padding(.leading)
                        //                        if let url = viewModel.user?.profileImageURL {
                        //                            AsyncImage(url: url) { image in
                        //                                image
                        //                                    .resizable()
                        //                                    .scaledToFill()
                        //                            } placeholder: {
                        //                                Image(systemName: "dog.fill")
                        //                            }
                        //                            .frame(width: 100, height: 100)
                        //                            .clipShape(Circle())
                        //                            .overlay(Circle().stroke(.white, lineWidth: 3))
                        //                            .shadow(radius: 6)
                        //                            .padding(.leading)
                        //                        }
                        VStack(alignment: .leading) {
                            Text(
                                "\(viewModel.user?.firstName ?? "") \(viewModel.user?.lastName ?? "")"
                            )
                            .font(.headline)
                            Text(viewModel.user?.userName ?? "")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                        }

                        Spacer()
                    }

                }
                HStack {
                    Spacer()
                    VStack {
                        Text(viewModel.user?.biography ?? "")
                        Text("Interests: ")
                        ForEach(viewModel.user?.techInterests ?? [], id: \.self)
                        { interest in
                            Text(interest)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 2)
                        }
                    }
                    Spacer()
                }  // contains interests view
                .glassEffect()

                if viewModel.currentUserPosts.isEmpty {
                    Text("No posts yet")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                } else {
                    List(viewModel.currentUserPosts) { post in
                        SinglePostView(
                            post: post,
                            networkClient: networkClient,
                            currentUserID: viewModel.user?.id,
                            onDeleted: { Task { await viewModel.load() } },
                            onEdit: { postToEdit in
                                editingPost = postToEdit
                                draftTitle = postToEdit.title
                                draftBody = postToEdit.body
                                postErrorMessage = nil
                                isShowingEditPostSheet = true
                            },
                            onPostUpdated: { updatedPost in
                                // Update the post in both lists
                                viewModel.updatePostInLists(updatedPost)
                            }
                        )
                        .listRowInsets(
                            EdgeInsets(
                                top: 8,
                                leading: 16,
                                bottom: 8,
                                trailing: 16
                            )
                        )
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                Spacer()
                Button("New Post") {
                    postErrorMessage = nil
                    isShowingNewPostSheet = true
                }
                .padding()
                .glassEffect()
                .sheet(isPresented: $isShowingNewPostSheet) {
                    NavigationStack {
                        Form {
                            if let message = postErrorMessage {
                                Section {
                                    Text(message)
                                        .foregroundStyle(.red)
                                }
                            }
                            Section(header: Text("Title")) {
                                TextField(
                                    "What's on your mind?",
                                    text: $draftTitle
                                )
                            }
                            Section(header: Text("Body")) {
                                TextEditor(text: $draftBody)
                                    .frame(minHeight: 160)
                            }
                        }
                        .navigationTitle("New Post")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Discard") {
                                    postErrorMessage = nil
                                    draftTitle = ""
                                    draftBody = ""
                                    isShowingNewPostSheet = false
                                }
                                .disabled(isSavingPost)
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Post") {
                                    saveNewPost()
                                }
                                .disabled(
                                    isSavingPost
                                        || draftTitle.trimmingCharacters(
                                            in: .whitespacesAndNewlines
                                        ).isEmpty
                                )
                            }
                        }
                    }
                }
                .sheet(isPresented: $isShowingEditPostSheet) {
                    NavigationStack {
                        Form {
                            if let message = postErrorMessage {
                                Section {
                                    Text(message)
                                        .foregroundStyle(.red)
                                }
                            }
                            Section(header: Text("Title")) {
                                TextField(
                                    "What's on your mind?",
                                    text: $draftTitle
                                )
                            }
                            Section(header: Text("Body")) {
                                TextEditor(text: $draftBody)
                                    .frame(minHeight: 160)
                            }
                        }
                        .navigationTitle("Edit Post")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    postErrorMessage = nil
                                    draftTitle = ""
                                    draftBody = ""
                                    editingPost = nil
                                    isShowingEditPostSheet = false
                                }
                                .disabled(isSavingPost)
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Save") {
                                    savePostEdits()
                                }
                                .disabled(
                                    isSavingPost
                                        || draftTitle.trimmingCharacters(
                                            in: .whitespacesAndNewlines
                                        ).isEmpty
                                )
                            }
                        }
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [.white, .white, .white, .white, .gray],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .toolbar {
                ToolbarItem {
                    Button("Edit Profile") {
                        if let user = viewModel.user {
                            editUserName = user.userName
                            editBio = user.biography
                            editTechInterests = user.techInterests.joined(
                                separator: ", "
                            )
                        }
                        profileErrorMessage = nil
                        isShowingEditProfile = true
                    }
                }
            }
            .sheet(isPresented: $isShowingEditProfile) {
                NavigationStack {
                    Form {
                        Section(header: Text("Name")) {
                            TextField(
                                "First Name",
                                text: Binding(
                                    get: { viewModel.user?.firstName ?? "" },
                                    set: { _, _ in }
                                )
                            )
                            TextField(
                                "Last Name",
                                text: Binding(
                                    get: { viewModel.user?.lastName ?? "" },
                                    set: { _, _ in }
                                )
                            )
                            TextField(
                                "Username",
                                text: $editUserName
                            )
                        }
                        Section(header: Text("Bio")) {
                            TextEditor(text: $editBio)
                                .frame(minHeight: 120)
                        }
                        Section(
                            header: Text("Tech Interests (comma-separated)")
                        ) {
                            TextField(
                                "e.g. Swift, SwiftUI, AI",
                                text: $editTechInterests
                            )
                        }
                        if let message = profileErrorMessage {
                            Section {
                                Text(message)
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .navigationTitle("Edit Profile")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isShowingEditProfile = false
                            }
                            .disabled(isSavingProfile)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                saveProfileEdits()
                            }
//                            .disabled(
//                                isSavingProfile
//                                    || editUserName.trimmingCharacters(
//                                        in: .whitespacesAndNewlines
//                                    ).isEmpty
//                            )
                        }
                    }
                }
            }  // edit profile view
            .task {
                await viewModel.load()  // load profile and posts from API
            }
        }
    }

    private func saveNewPost() {
        postErrorMessage = nil
        isSavingPost = true

        Task {
            do {
                try await viewModel.saveNewPost(
                    title: draftTitle,
                    body: draftBody
                )
                await MainActor.run {
                    draftTitle = ""
                    draftBody = ""
                    postErrorMessage = nil
                    isShowingNewPostSheet = false
                    isSavingPost = false
                }
            } catch {
                await MainActor.run {
                    if let saveError = error as? ProfileSaveError,
                        case .emptyTitle = saveError
                    {
                        postErrorMessage = "Please enter a title."
                    } else {
                        postErrorMessage =
                            "Failed to save post: \(error.localizedDescription)"
                    }
                    isSavingPost = false
                }
            }
        }
    }

    private func savePostEdits() {
        guard let post = editingPost else { return }
        postErrorMessage = nil
        isSavingPost = true

        Task {
            do {
                try await viewModel.savePostEdits(
                    postId: post.id,
                    title: draftTitle,
                    body: draftBody
                )
                await MainActor.run {
                    draftTitle = ""
                    draftBody = ""
                    postErrorMessage = nil
                    editingPost = nil
                    isShowingEditPostSheet = false
                    isSavingPost = false
                }
            } catch {
                await MainActor.run {
                    if let saveError = error as? ProfileSaveError,
                        case .emptyTitle = saveError
                    {
                        postErrorMessage = "Please enter a title."
                    } else {
                        postErrorMessage =
                            "Failed to update post: \(error.localizedDescription)"
                    }
                    isSavingPost = false
                }
            }
        }
    }

    private func saveProfileEdits() {
        isSavingProfile = true
        profileErrorMessage = nil

        Task {
            do {
                try await viewModel.saveProfileEdits(
                    userName: editUserName,
                    bio: editBio,
                    techInterests: editTechInterests
                )
                await MainActor.run {
                    isSavingProfile = false
                    isShowingEditProfile = false
                }
            } catch {
                await MainActor.run {
                    if let saveError = error as? ProfileSaveError,
                        case .emptyUsername = saveError
                    {
                        profileErrorMessage = "Username cannot be empty."
                    } else {
                        profileErrorMessage =
                            "Failed to save profile: \(error.localizedDescription)"
                    }
                    isSavingProfile = false
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
