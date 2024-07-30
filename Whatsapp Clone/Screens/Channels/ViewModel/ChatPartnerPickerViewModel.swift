//
//  ChatPartnerPickerViewModel.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 26/07/24.
//

import Foundation
import Firebase
import FirebaseAuth

enum ChannelCreationRoute {
    case groupPartnerPicker
    case setupGroupChat
}

enum ChannelConstant {
    static let maxGroupParticipant = 12
}


final class ChatPartnerPickerViewModel: ObservableObject {
    @Published var navStack = [ChannelCreationRoute]()
    @Published var selectedChatPartners = [UserItem]()
    @Published private(set) var users = [UserItem]()
    private var lastCursor: String?
    
    var showSelectedUsers: Bool {
        return !selectedChatPartners.isEmpty
    }
    
    var disableNextButton: Bool {
        return selectedChatPartners.isEmpty
    }
    
    var isPaginatable: Bool {
        print("user count \(users.count)")
        return !users.isEmpty
    }
    
    init() {
        Task {
            await fetchUsers()
        }
    }
    
    func fetchUsers() async {
        do {
            let userNode = try await UserService.paginateUsers(lastCursor: lastCursor, pageSize: 5)
            var fetchedUser = userNode.users
            
            // Filter not showing current user
            guard let currentId = Auth.auth().currentUser?.uid else { return }
            fetchedUser = fetchedUser.filter { $0.uid == currentId }
            
            
            self.users.append(contentsOf: fetchedUser)
            self.lastCursor = userNode.currentCursor
            
            print("Check -> lastCursor : \(lastCursor)")
        } catch {
            print("Failed to fetch users in chat")
        }
    }
    
    func handleItemSelection(_ item: UserItem) {
        if isUserSelected(item) {
            // deselect
            guard let index = selectedChatPartners.firstIndex(where: { $0.uid == item.uid }) else { return }
            selectedChatPartners.remove(at: index)
        } else {
            // Select
            selectedChatPartners.append(item)
        }
    }
    
    func isUserSelected(_ user: UserItem) -> Bool {
        let isSelected = selectedChatPartners.contains{ $0.uid == user.uid }
        return isSelected
    }
    
}
