//
//  AuthScreenModel.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 24/07/24.
//

import Foundation

final class AuthScreenModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var isLoading = false
    @Published var errorState: (showError: Bool, errorMessage: String) = (false, "Uh Oh")
    
    var disableLoginButton: Bool {
        return email.isEmpty || password.isEmpty || isLoading
    }
    
    var disableSignUpButton: Bool {
        return email.isEmpty || password.isEmpty || username.isEmpty || isLoading
    }
    
    func handleSignUp() async {
        isLoading = true
        do {
            try await AuthManager.shared.createAccount(for: username, with: email, and: password)
        } catch {
            errorState.errorMessage = "Failed to create ana account \(error.localizedDescription)"
            errorState.showError = true
            isLoading = false
        }
    }
}
