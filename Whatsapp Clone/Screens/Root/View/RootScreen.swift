//
//  RootScreen.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 25/07/24.
//

import SwiftUI

struct RootScreen: View {
    @StateObject private var viewModel = RootScreenModel()
    var body: some View {
        switch viewModel.authState {
        case .pending:
            ProgressView()
                .controlSize(.large)
        case .loggedIn(let loggedInUser):
            MainTabView()
        case .loggedOut:
            LoginScreen()
        }
    }
}

#Preview {
    RootScreen()
}
