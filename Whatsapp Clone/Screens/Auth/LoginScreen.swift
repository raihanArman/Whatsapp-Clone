//
//  LoginScreen.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 24/07/24.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject private var authViewModel = AuthScreenModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                AuthHeaderView()
                
                
                AuthTextField(type: .email, text: $authViewModel.email)
                AuthTextField(type: .password, text: $authViewModel.password)
                
                forgotPasswordButton()
                
                AuthButton(title: "Login", onTap: {
                    Task {
                        await authViewModel.handleLogin()
                    }
                })
                .disabled(authViewModel.disableLoginButton)
                
                Spacer()
                signUpButton()
                    .padding(.bottom, 30)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(Color.teal.gradient)
            .ignoresSafeArea()
            .alert(isPresented: $authViewModel.errorState.showError) {
                Alert(
                    title: Text(authViewModel.errorState.errorMessage),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
    }
    
    private func forgotPasswordButton() -> some View {
        Button {
            
        } label: {
            Text("Forgot Password ?")
                .foregroundStyle(.white)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                .padding(.trailing, 32)
                .bold()
                .padding(.vertical)
        }
    }
    
    private func signUpButton() -> some View {
        NavigationLink {
            SignUpScreen(authScreenModel: authViewModel)
        } label: {
            HStack {
                Image(systemName: "sparkles")
                (
                    Text("Don't have an account? ")
                    +
                    Text("Create account").bold()
                )
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    LoginScreen()
}
