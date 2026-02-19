//
//  UserRepository.swift
//  TSMA
//
//  Created by Nathan Lambson on 11/5/25.
//

import Foundation
internal import System

protocol UserRepositoryProtocol {
    func fetchCurrentUser() async throws -> User
}

struct MockUserRepository: UserRepositoryProtocol {
    func fetchCurrentUser() async throws -> User {
        User(
            id: "u1",
            firstName: "Bridger",
            lastName: "Mason",
            userName: "claybm",
            biography: "iOS developer and student",
            techInterests: ["Swift", "SwiftUI"],
            profileImageURL: URL(string: "https://scontent-sjc6-1.xx.fbcdn.net/v/t39.30808-6/465722803_540836045437033_6076916854729839278_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=skAr7iYVmCYQ7kNvwF6La1H&_nc_oc=Adki6fdfVtjhDE3Xd1x6JG8yrMeosGxtsu2cvJrF3P1Z0y-rRVOM7pWInCAJG-N3TtM&_nc_zt=23&_nc_ht=scontent-sjc6-1.xx&_nc_gid=Z5_my9ANGIqNpy76PfjnJA&oh=00_Afi7xGz9IT4Zd0M2SKLy3bZBus88ZYirxBBI-0iJCoo-Zw&oe=6921C11D"),
            coverImageURL: URL(string:
                                "https://scontent-sjc3-1.xx.fbcdn.net/v/t39.30808-6/473275262_587010774152893_5669376475237111849_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=cc71e4&_nc_ohc=x8sQ9w0pdWgQ7kNvwGqDVxz&_nc_oc=AdmIZb0ozvUb_pj3zNETZq8KJSjnZVbcIVpT2ba4p0yrV7OIRoQ8pd4Moc2fdeitoHY&_nc_zt=23&_nc_ht=scontent-sjc3-1.xx&_nc_gid=mLk8MxWvGl6JjeZusFcpaA&oh=00_AfhxHXPS9AFqDY0-H0RrD4DioOeVNgf8Q8OYJ8Cb7_CR5A&oe=6921A55B"
                              )
        ) // placeholder user
    }
}

struct APIUserRepository: UserRepositoryProtocol {
    private let networkClient: NetworkClientProtocol
    private let userUUID: String
    
    init(networkClient: NetworkClientProtocol, userUUID: String) {
        self.networkClient = networkClient
        self.userUUID = userUUID
    }
    
    func fetchCurrentUser() async throws -> User {
        guard let apiClient = networkClient as? APINetworkClient else {
            throw NetworkError.systemError
        }
        return try await apiClient.fetchUser(userID: userUUID)
    }
}
