//
//  NetworkClient.swift
//  Project #7 - Social Media App
//
//  Created by Bridger Mason on 11/17/25.
//

import Foundation

protocol NetworkClientProtocol: Sendable {  
    func fetchCurrentUser() async throws -> User
    func fetchPosts(pageNumber: Int) async throws -> [Post]
    /// Fetch comments for a given post.
    /// - Parameter postId: The id of the post whose comments should be returned.
    func fetchComments(postId: String) async throws -> [Comment]
    func createPost(title: String, body: String) async throws -> Post
    func updateProfile(userName: String, bio: String?, techInterests: String?) async throws -> User
    /// Delete a post owned by the current user.
    func deletePost(postId: String) async throws
    /// Update a post owned by the current user.
    func updatePost(postId: String, title: String, body: String) async throws -> Post
    /// Toggle like/unlike for a post.
    func likePost(postId: String) async throws -> Post
}

nonisolated struct PostResponseDTO: Codable, Sendable {
    let postID: String
    let title: String
    let body: String
    let authorUserName: String
    let authorUserId: String
    let likes: Int
    let userLiked: Bool
    let numComments: Int
    let createdDate: String
}

nonisolated struct CommentResponseDTO: Codable, Sendable {
    let commentId: String
    let body: String
    let userName: String
    let userId: String
    let createdDate: String
}

nonisolated struct UserProfileResponseDTO: Codable, Sendable {
    let firstName: String
    let lastName: String
    let userName: String
    let userUUID: String
    let bio: String?
    let techInterests: String?
    let posts: [PostResponseDTO]?
}

nonisolated struct CreatePostRequestDTO: Encodable, Sendable {
    let post: PostPayload
    
    nonisolated struct PostPayload: Encodable, Sendable {
        let title: String
        let body: String
    }
}

nonisolated struct UpdateProfileRequestDTO: Encodable, Sendable {
    let profile: ProfilePayload
    
    nonisolated struct ProfilePayload: Encodable, Sendable {
        let userName: String
        let bio: String?
        let techInterests: String?
    }
}

enum NetworkError: Error {
    case invalidURL
    case badResponse(statusCode: Int)
    case decodingError
    case unauthorized
    case systemError
}

actor MockNetworkClient: NetworkClientProtocol { // This is only for testing
    func fetchCurrentUser() async throws -> User {
        try await Task.sleep(nanoseconds: 80_000_000)
        return await Self.sampleAda
    }
    func fetchComments(postId: String) async throws -> [Comment] { // Fetches comments for the current post
        // In a real implementation this would hit your backend and the
        // backend would enforce the cascade delete rule (when a post is
        // deleted, all comments whose `postId` matches that post are deleted).
        return await [
            Comment(
                id: "c1",
                postId: postId,
                author: MockNetworkClient.sampleAlan,
                body: "Bro what, that's crazy",
                likeCount: 4,
                replyCount: 0,
                createdAt: .now
            )
        ]
    }
    func fetchPosts(pageNumber: Int) async throws -> [Post] { // Fetches all posts for PostsView
        try await Task.sleep(nanoseconds: 120_000_000)
        return await [
            Post(id: "p1",
                 author: Self.sampleAda,
                 title: "Welcome",
                 body: "This is the first sample post.",
                 likeCount: 12,
                 commentCount: 3,
                 createdAt: .now,
                 userLiked: false),
            Post(id: "p2",
                 author: Self.sampleAlan,
                 title: "Second Post",
                 body: "Timeline loads from a repository.",
                 likeCount: 7,
                 commentCount: 1,
                 createdAt: .now.addingTimeInterval(-3600),
                 userLiked: false)
        ]
    }
    
    func createPost(title: String, body: String) async throws -> Post {
        try await Task.sleep(nanoseconds: 50_000_000)
        return await Post(
            id: "p_new",
            author: Self.sampleAda,
            title: title,
            body: body,
            likeCount: 0,
            commentCount: 0,
            createdAt: .now,
            userLiked: false
        )
    }
    
    func updateProfile(userName: String, bio: String?, techInterests: String?) async throws -> User {
        try await Task.sleep(nanoseconds: 50_000_000)
        let interests = techInterests?
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty } ?? []
        
        let base = await Self.sampleAda
        return User(
            id: base.id,
            firstName: base.firstName,
            lastName: base.lastName,
            userName: userName,
            biography: bio ?? base.biography,
            techInterests: interests.isEmpty ? base.techInterests : interests,
            profileImageURL: base.profileImageURL,
            coverImageURL: base.coverImageURL
        )
    }
    
    func deletePost(postId: String) async throws {
        try await Task.sleep(nanoseconds: 30_000_000)
    }
    
    func updatePost(postId: String, title: String, body: String) async throws -> Post {
        try await Task.sleep(nanoseconds: 50_000_000)
        return await Post(
            id: postId,
            author: Self.sampleAda,
            title: title,
            body: body,
            likeCount: 0,
            commentCount: 0,
            createdAt: .now,
            userLiked: false
        )
    }
    
    func likePost(postId: String) async throws -> Post {
        try await Task.sleep(nanoseconds: 30_000_000)
        // Return a post with incremented like count for mock
        return await Post(
            id: postId,
            author: Self.sampleAda,
            title: "Sample Post",
            body: "Sample body",
            likeCount: 1,
            commentCount: 0,
            createdAt: .now,
            userLiked: true
        )
    }

    private static let sampleAda = User(
        id: "u_ada",
        firstName: "Ada",
        lastName: "Lovelace",
        userName: "@ada",
        biography: "Poet of numbers",
        techInterests: ["Swift","Architecture","UI"],
        profileImageURL: nil,
        coverImageURL: nil
    )

    private static let sampleAlan = User(
        id: "u_alan",
        firstName: "Alan",
        lastName: "Turing",
        userName: "@A_Turing",
        biography: "Just a dude.",
        techInterests: ["Math","programming"],
        profileImageURL: nil,
        coverImageURL: nil
    )
}


// Real NetworkClient Implementation

actor APINetworkClient: NetworkClientProtocol {
    private let baseURL = "https://social-media-app.ryanplitt.com"
    private let authSecret: String?
    private var userCache: [String: User] = [:]
    
    init(authSecret: String?) {
        self.authSecret = authSecret
    }
    
    private func createRequest(endpoint: String, method: String = "GET", body: Data? = nil) throws -> URLRequest {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let secret = authSecret {
            request.setValue("Bearer \(secret)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    private func performRequest<T: Decodable>(_ request: URLRequest, responseType: T.Type) async throws -> T {
        let session = URLSession.shared
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.systemError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                throw NetworkError.unauthorized
            }
            throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
    
    func fetchCurrentUser() async throws -> User {
        throw NetworkError.systemError 
    }
    
    func fetchUser(userID: String) async throws -> User {
        if let cachedUser = userCache[userID] {
            return cachedUser
        }
        
        let userDTO = try await fetchUserProfile(userID: userID)
        let user = User(
            id: userDTO.userUUID,
            firstName: userDTO.firstName,
            lastName: userDTO.lastName,
            userName: userDTO.userName,
            biography: userDTO.bio ?? "",
            techInterests: userDTO.techInterests?.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) } ?? [],
            profileImageURL: nil,
            coverImageURL: nil
        )
        
        userCache[userID] = user
        return user
    }
    
    func fetchPosts(pageNumber: Int) async throws -> [Post] {
        let endpoint = pageNumber == 0 ? "/posts" : "/posts/\(pageNumber)"
        let request = try createRequest(endpoint: endpoint)
        let postsDTO: [PostResponseDTO] = try await performRequest(request, responseType: [PostResponseDTO].self)
        
        // Convert DTOs to domain models
        // Get unique user IDs first to batch fetch
        let uniqueUserIDs = Set(postsDTO.map { $0.authorUserId })
        
        // Fetch all unique users
        var users: [String: User] = [:]
        for userID in uniqueUserIDs {
            users[userID] = try await fetchUser(userID: userID)
        }
        
        // Map posts with cached users
        let dateFormatter = ISO8601DateFormatter()
        return postsDTO.map { postDTO in
            let author = users[postDTO.authorUserId] ?? User(
                id: postDTO.authorUserId,
                firstName: "",
                lastName: "",
                userName: postDTO.authorUserName,
                biography: "",
                techInterests: [],
                profileImageURL: nil,
                coverImageURL: nil
            )
            
            let createdAt = dateFormatter.date(from: postDTO.createdDate) ?? Date()
            
            return Post(
                id: postDTO.postID,
                author: author,
                title: postDTO.title,
                body: postDTO.body,
                likeCount: postDTO.likes,
                commentCount: postDTO.numComments,
                createdAt: createdAt,
                userLiked: postDTO.userLiked
            )
        }
    }
    
    func fetchComments(postId: String) async throws -> [Comment] {
        let endpoint = "/post/\(postId)/comments?pageNumber=0"
        let request = try createRequest(endpoint: endpoint)
        let commentsDTO: [CommentResponseDTO] = try await performRequest(request, responseType: [CommentResponseDTO].self)
        
        // Get unique user IDs for comments
        let uniqueUserIDs = Set(commentsDTO.map { $0.userId })
        
        // Fetch all unique users
        var users: [String: User] = [:]
        for userID in uniqueUserIDs {
            users[userID] = try await fetchUser(userID: userID)
        }
        
        // Map comments with cached users
        let dateFormatter = ISO8601DateFormatter()
        return commentsDTO.map { commentDTO in
            let author = users[commentDTO.userId] ?? User(
                id: commentDTO.userId,
                firstName: "",
                lastName: "",
                userName: commentDTO.userName,
                biography: "",
                techInterests: [],
                profileImageURL: nil,
                coverImageURL: nil
            )
            
            let createdAt = dateFormatter.date(from: commentDTO.createdDate) ?? Date()
            
            return Comment(
                id: commentDTO.commentId,
                postId: postId,
                author: author,
                body: commentDTO.body,
                likeCount: 0, // API doesn't provide this
                replyCount: 0, // API doesn't provide this
                createdAt: createdAt
            )
        }
    }
    
    private func fetchUserProfile(userID: String) async throws -> UserProfileResponseDTO {
        let endpoint = "/user/\(userID)"
        let request = try createRequest(endpoint: endpoint)
        return try await performRequest(request, responseType: UserProfileResponseDTO.self)
    }
    
    func createPost(title: String, body: String) async throws -> Post {
        let payload = CreatePostRequestDTO(post: .init(title: title, body: body))
        let encoder = JSONEncoder()
        let bodyData = try encoder.encode(payload)
        
        let request = try createRequest(endpoint: "/post", method: "POST", body: bodyData)
        let postDTO: PostResponseDTO = try await performRequest(request, responseType: PostResponseDTO.self)
        
        let author = try await fetchUser(userID: postDTO.authorUserId)
        let dateFormatter = ISO8601DateFormatter()
        let createdAt = dateFormatter.date(from: postDTO.createdDate) ?? Date()
        
        return Post(
            id: postDTO.postID,
            author: author,
            title: postDTO.title,
            body: postDTO.body,
            likeCount: postDTO.likes,
            commentCount: postDTO.numComments,
            createdAt: createdAt,
            userLiked: postDTO.userLiked
        )
    }
    
    func updateProfile(userName: String, bio: String?, techInterests: String?) async throws -> User {
        let payload = UpdateProfileRequestDTO(
            profile: .init(
                userName: userName,
                bio: bio,
                techInterests: techInterests
            )
        )
        let encoder = JSONEncoder()
        let bodyData = try encoder.encode(payload)
        
        let request = try createRequest(endpoint: "/user/update-profile", method: "POST", body: bodyData)
        let dto: UserProfileResponseDTO = try await performRequest(request, responseType: UserProfileResponseDTO.self)
        
        return User(
            id: dto.userUUID,
            firstName: dto.firstName,
            lastName: dto.lastName,
            userName: dto.userName,
            biography: dto.bio ?? "",
            techInterests: dto.techInterests?
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty } ?? [],
            profileImageURL: nil,
            coverImageURL: nil
        )
    }
    
    func deletePost(postId: String) async throws {
        let request = try createRequest(endpoint: "/post/\(postId)", method: "DELETE")
        let session = URLSession.shared
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.systemError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                throw NetworkError.unauthorized
            }
            throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
        }
    }
    
    func updatePost(postId: String, title: String, body: String) async throws -> Post {
        let payload = CreatePostRequestDTO(post: .init(title: title, body: body))
        let encoder = JSONEncoder()
        let bodyData = try encoder.encode(payload)
        
        // API endpoint: POST /post/edit/:postID
        let request = try createRequest(endpoint: "/post/edit/\(postId)", method: "POST", body: bodyData)
        let postDTO: PostResponseDTO = try await performRequest(request, responseType: PostResponseDTO.self)
        
        let author = try await fetchUser(userID: postDTO.authorUserId)
        let dateFormatter = ISO8601DateFormatter()
        let createdAt = dateFormatter.date(from: postDTO.createdDate) ?? Date()
        
        return Post(
            id: postDTO.postID,
            author: author,
            title: postDTO.title,
            body: postDTO.body,
            likeCount: postDTO.likes,
            commentCount: postDTO.numComments,
            createdAt: createdAt,
            userLiked: postDTO.userLiked
        )
    }
    
    func likePost(postId: String) async throws -> Post {
        // API endpoint: POST /post/:postID/like
        let request = try createRequest(endpoint: "/post/\(postId)/like", method: "POST")
        let postDTO: PostResponseDTO = try await performRequest(request, responseType: PostResponseDTO.self)
        
        let author = try await fetchUser(userID: postDTO.authorUserId)
        let dateFormatter = ISO8601DateFormatter()
        let createdAt = dateFormatter.date(from: postDTO.createdDate) ?? Date()
        
        return Post(
            id: postDTO.postID,
            author: author,
            title: postDTO.title,
            body: postDTO.body,
            likeCount: postDTO.likes,
            commentCount: postDTO.numComments,
            createdAt: createdAt,
            userLiked: postDTO.userLiked
        )
    }
}

// Helper extension for async map
extension Sequence {
    func asyncMap<T>(_ transform: @escaping (Element) async throws -> T) async rethrows -> [T] {
        var results: [T] = []
        for element in self {
            try await results.append(transform(element))
        }
        return results
    }
}

// Helper function to add Bearer token authentication to a request
func addBearerToken(to request: inout URLRequest, secret: String) {
    request.setValue("Bearer \(secret)", forHTTPHeaderField: "Authorization")
}

//GET
func APIRequest() async throws {
    let request = URLRequest(url: URL(string: "https://www.google.com")!)
    let session = URLSession.shared
    do {
        _ = try await session.data(for: request)
    } catch {
        print(error)
        throw error
    }
}

//POST
struct LoginInput: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let userUUID: String  // API returns UUID as string
    let secret: String    // API returns UUID as string
    let userName: String
}

enum LoginError: Error {
    case badResponse
    case systemError
    case invalidURL
    case decodingError
}

func login(email: String, password: String) async throws -> LoginResponse {
    let loginInput = LoginInput(email: email, password: password)
    let jsonEncoder = JSONEncoder()
    
    do {
        let data = try jsonEncoder.encode(loginInput)
        
        guard let url = URL(string: "https://social-media-app.ryanplitt.com/auth/login") else {
            throw LoginError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let session = URLSession.shared
        
        let (responseData, urlResponse) = try await session.data(for: request)
        
        if let httpResponse = urlResponse as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                let jsonDecoder = JSONDecoder()
                do {
                    let response = try jsonDecoder.decode(
                                        LoginResponse.self,
                                        from: responseData
                                    )
                    return response
                } catch {
                    print("Decoding error: \(error)")
                    throw LoginError.decodingError
                }
            } else {
                print("Error: \(httpResponse.statusCode)")
                throw LoginError.badResponse
            }
        } else {
            print("error")
            throw LoginError.systemError
        }
        
    } catch {
        print(error)
        throw error
    }
}
