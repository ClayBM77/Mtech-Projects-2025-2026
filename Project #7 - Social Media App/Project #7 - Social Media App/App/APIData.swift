//
//  AppServices.swift
//  Project #7 - Social Media App
//
//  Created by Bridger Mason on 11/17/25.
//

import Foundation

@Observable
final class APIData {
    private(set) var isReady: Bool = true
    private(set) var authSecret: String?
    private(set) var currentUserUUID: String?

    var networkClient: NetworkClientProtocol
    var userRepository: UserRepositoryProtocol

    init(networkClient: NetworkClientProtocol, userRepository: UserRepositoryProtocol) {
        self.networkClient = networkClient
        self.userRepository = userRepository
    }
    
    func setAuthSecret(_ secret: String, userUUID: String) {
        authSecret = secret
        currentUserUUID = userUUID
        // new secret
        networkClient = APINetworkClient(authSecret: secret)
        userRepository = APIUserRepository(networkClient: networkClient, userUUID: userUUID)
    }
    
    func clearAuthSecret() {
        authSecret = nil
        currentUserUUID = nil
        networkClient = APINetworkClient(authSecret: nil)
        userRepository = MockUserRepository()
    }
    
    var isAuthenticated: Bool {
        authSecret != nil
    }
}
