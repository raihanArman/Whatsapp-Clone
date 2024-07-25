//
//  RootScreenModel.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 25/07/24.
//

import Foundation
import Combine

final class RootScreenModel: ObservableObject {
    @Published private(set) var authState = AuthState.pending
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = AuthManager.shared.authState.receive(on: DispatchQueue.main)
            .sink {[weak self] latestAuthState in
                self?.authState = latestAuthState
            }
    }
}
