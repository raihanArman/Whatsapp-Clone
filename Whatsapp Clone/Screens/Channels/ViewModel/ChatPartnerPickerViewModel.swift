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

enum ChannelCreationError: Error {
    case noChatPartner
    case failedToCreateUniqueIds
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
            fetchedUser = fetchedUser.filter { $0.uid != currentId }
            
            
            self.users.append(contentsOf: fetchedUser)
            self.lastCursor = userNode.currentCursor
            
            print("Check -> lastCursor : \(lastCursor) fetchedUser")
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
    
//    func buildDirectChannel() async -> Result<ChannelItem, Error> {
//        
//    }
    
    func createChannel(_ channelName: String?) -> Result<ChannelItem, Error> {
        guard !selectedChatPartners.isEmpty else { return .failure(ChannelCreationError.noChatPartner)}
        
        guard let channelId = FirebaseConstants.ChannelRef.childByAutoId().key,
              let currentUid = Auth.auth().currentUser?.uid,
              let messageId = FirebaseConstants.MessageRef.childByAutoId().key
        else { return .failure(ChannelCreationError.failedToCreateUniqueIds) }
        
        let timeStamp = Date().timeIntervalSince1970
        var memberUids = selectedChatPartners.compactMap { $0.uid }
        memberUids.append(currentUid)
        
        var channelDict: [String: Any] = [
            .id: channelId,
            .lastMessage: "",
            .creationDate: timeStamp,
            .lastMessageTimeStamp: timeStamp,
            .memberUids: memberUids,
            .membersCount: memberUids.count,
            .adminUids: [currentUid]
        ]
        
        if let channelName = channelName, channelName.isEmptyOrWhiteSpace {
            channelDict[.name] = channelName
        }
        
        
//        let messageDict: [String: Any] = ["type":, "timeStamp": timeStamp, "ownerUid": currentUid]
        
        FirebaseConstants.ChannelRef.child(channelId).setValue(channelDict)
        
        memberUids.forEach { userId in
            /// keeping an index of channel that a specific user belong to
            FirebaseConstants.UserChannelRef.child(userId).child(channelId).setValue(true)
            
            /// Makes sure that a direct channel is unique
            FirebaseConstants.UserDirectionChannels.child(userId).setValue(true)
        }
        
        let newChannelItem = ChannelItem(channelDict)
        return .success(newChannelItem)
    }
    
}
