//
//  LoginState.swift
//  Project #7 - Social Media App
//
//  Created by Bridger Mason on 2/9/26.
//

import Foundation

enum LoginState: Equatable {
    case idle
    case loading
    case success
    case error(String)
    
    var message: String? {
        switch self {
        case .idle:
            return nil
        case .loading:
            return "Logging in..."
        case .success:
            return "Login successful!"
        case .error(let message):
            return message
        }
    }
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
    
    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
}
