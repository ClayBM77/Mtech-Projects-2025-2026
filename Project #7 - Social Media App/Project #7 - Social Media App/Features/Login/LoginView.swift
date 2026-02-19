//
//  LoginView.swift
//  AdvancedViewModifiers
//
//  Created by Bridger Mason on 1/30/26.
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    @Environment(APIData.self) private var appServices
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Log In")
                .fontWeight(.semibold)
            // Email Field
            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                
            
            // Password Field
            SecureField("Password", text: $viewModel.password)
                
            
            // Status Message Area
            if let message = viewModel.loginState.message {
                HStack {
                    if viewModel.loginState == .loading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: viewModel.loginState.isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                            .foregroundColor(viewModel.loginState.isSuccess ? .green : .red)
                    }
                    
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(viewModel.loginState.isSuccess ? .green : viewModel.loginState.isError ? .red : .primary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(viewModel.loginState.isSuccess ? Color.green.opacity(0.1) : viewModel.loginState.isError ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
                )
                .transition(.opacity.combined(with: .scale))
            }
            
            // Login Button
            Button(action: {
                handleLogin()
            }) {
                Text("Login")
                    .fontWeight(.semibold)
            }
            .padding()
            .glassEffect()
            .disabled(viewModel.loginState == .loading)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 40)
        .animation(.easeInOut, value: viewModel.loginState)
    }
    
    // MARK: - Helper Methods
    
    private func handleLogin() {
        viewModel.login { response in
            // Called on main actor from the view model
            appServices.setAuthSecret(response.secret, userUUID: response.userUUID)
            // Navigate to main app after a brief delay so the success UI can show
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isLoggedIn = true
            }
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
        .environment(APIData(networkClient: MockNetworkClient(), userRepository: MockUserRepository()))
}
