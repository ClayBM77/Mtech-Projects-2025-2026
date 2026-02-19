//
//  LoginViewModel.swift
//  Project #7 - Social Media App
//
//  Created by Bridger Mason on 2/13/26.
//

import Foundation

@MainActor
@Observable
final class LoginViewModel {
    var email: String = "bridger.mason@icloud.com"
    var password: String = "baZsur-juwdof-6ciqse"
    var loginState: LoginState = .idle
    
    /// Validates the current email and password.
    /// Returns an error message string if invalid, or nil if valid.
    private func validate() -> String? {
        guard !email.isEmpty && !password.isEmpty else {
            return "Please fill in all fields"
        }
        
        guard email.contains("@") && email.contains(".") else {
            return "Please enter a valid email address"
        }
        
        return nil
    }
    
    /// Attempts to log in using the auth API.
    /// On success, calls the `onAuthenticated` closure with the `LoginResponse`.
    func login(onAuthenticated: @escaping (LoginResponse) -> Void) {
        if let message = validate() {
            loginState = .error(message)
            return
        }
        
        loginState = .loading
        
        Task {
            do {
                let response = try await Project__7___Social_Media_App.login(email: email, password: password)
                await MainActor.run {
                    self.loginState = .success
                    onAuthenticated(response)
                }
            } catch {
                await MainActor.run {
                    if let loginError = error as? LoginError {
                        switch loginError {
                        case .badResponse:
                            self.loginState = .error("Invalid email or password")
                        case .decodingError:
                            self.loginState = .error("Invalid response from server")
                        case .invalidURL:
                            self.loginState = .error("Invalid server URL")
                        case .systemError:
                            self.loginState = .error("System error occurred")
                        }
                    } else {
                        self.loginState = .error("Login failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

