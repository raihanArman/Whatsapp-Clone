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
    @Published var errorState: (showError: Bool, errorMessage: String) = (false, "Uh Oh")
    
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
    
    private var isDirectChannel: Bool {
        return selectedChatPartners.count == 1
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
            print("Check -> currentId \(currentId)")
            fetchedUser = fetchedUser.filter { $0.uid != currentId }
            
            
            self.users.append(contentsOf: fetchedUser)
            self.lastCursor = userNode.currentCursor
            
            print("Check -> lastCursor : \(lastCursor) fetchedUser")
        } catch {
            print("Failed to fetch users in chat")
        }
    }
    
    func doSelectAllChatPartner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.selectedChatPartners.removeAll()
        }
    }
    
    func handleItemSelection(_ item: UserItem) {
        if isUserSelected(item) {
            // deselect
            guard let index = selectedChatPartners.firstIndex(where: { $0.uid == item.uid }) else { return }
            selectedChatPartners.remove(at: index)
        } else {
            // Select
            guard selectedChatPartners.count < ChannelConstant.maxGroupParticipant else {
                let errorMessage = "Sorry We Only allow a maximum of \(ChannelConstant.maxGroupParticipant) participants in a group chat"
                showError(errorMessage)
                return
            }
            
            selectedChatPartners.append(item)
        }
    }
    
    func isUserSelected(_ user: UserItem) -> Bool {
        let isSelected = selectedChatPartners.contains{ $0.uid == user.uid }
        return isSelected
    }
    
    func createDirectChannel(_ chatPartner: UserItem, completion: @escaping (_ newChannel: ChannelItem) -> Void) {
        selectedChatPartners.append(chatPartner)
        
        Task {
            // If existing DM, get the channel
            if let channelId = await verifyIfDirectChannelIsExists(with: chatPartner.uid) {
                let snapshot = try await FirebaseConstants.ChannelRef.child(channelId).getData()
                var channelDict = snapshot.value as! [String: Any]
                var directChannel = ChannelItem(channelDict)
                directChannel.members = selectedChatPartners
                completion(directChannel)
            } else {
                // Create a new DM with the user
                let channelCreation = createChannel(nil)
                switch channelCreation {
                case .success(let channel):
                    completion(channel)
                case .failure(let failure):
                    showError("Sorry! Something went wrong while we were trying to setup your chat")
                    print("Failed to create a direct channel \(failure.localizedDescription)")
                }
            }
        }
    }
    
    typealias ChannelId = String
    private func verifyIfDirectChannelIsExists(with channelPartnerId: String) async -> ChannelId? {
        guard let currentUid = Auth.auth().currentUser?.uid,
              let snapshot = try? await FirebaseConstants.UserDirectionChannels.child(currentUid).child(channelPartnerId).getData(),
              snapshot.exists()
        else { return nil }
        
        let directMessageDict = snapshot.value as! [String: Bool]
        let channelId = directMessageDict.compactMap { $0.key }.first
        return channelId
    }
    
    private func showError(_ errorMessage: String) {
        errorState.errorMessage = errorMessage
        errorState.showError = true
    }
    
    func createGroupChannel(_ groupName: String?, completion: @escaping (_ newChannel: ChannelItem) -> Void) {
        let channelCreation = createChannel(groupName)
        switch channelCreation {
        case .success(let channel):
            completion(channel)
        case .failure(let failure):
            showError("Sorry! Something went wrong while we were trying to setup your group chat")
            print("Failed to create a group channel \(failure.localizedDescription)")
        }
    }
    
    private func createChannel(_ channelName: String?) -> Result<ChannelItem, Error> {
        guard !selectedChatPartners.isEmpty else { return .failure(ChannelCreationError.noChatPartner)}
        
        guard let channelId = FirebaseConstants.ChannelRef.childByAutoId().key,
              let currentUid = Auth.auth().currentUser?.uid,
              let messageId = FirebaseConstants.MessageRef.childByAutoId().key
        else { return .failure(ChannelCreationError.failedToCreateUniqueIds) }
        
        let timeStamp = Date().timeIntervalSince1970
        var memberUids = selectedChatPartners.compactMap { $0.uid }
        memberUids.append(currentUid)
        
        let newChannelBroadcast = AdminMessageType.channelCreation.rawValue
        
        var channelDict: [String: Any] = [
            .id: channelId,
            .lastMessage: newChannelBroadcast,
            .creationDate: timeStamp,
            .lastMessageTimeStamp: timeStamp,
            .memberUids: memberUids,
            .membersCount: memberUids.count,
            .adminUids: [currentUid],
            .createdBy: currentUid
        ]
        
        if let channelName = channelName, !channelName.isEmptyOrWhiteSpace {
            channelDict[.name] = channelName
        }
        
        
        let messageDict: [String: Any] = [.type: newChannelBroadcast, .timeStamp: timeStamp, .ownerUid: currentUid]
        
        FirebaseConstants.ChannelRef.child(channelId).setValue(channelDict)
        FirebaseConstants.MessageRef.child(channelId).child(messageId).setValue(messageDict)
        
        memberUids.forEach { userId in
            /// keeping an index of channel that a specific user belong to
            FirebaseConstants.UserChannelRef.child(userId).child(channelId).setValue(true)
        }
        
        /// Makes sure that a direct channel is unique
        if isDirectChannel {
            let chatPartner = selectedChatPartners[0]
            
            FirebaseConstants.UserDirectionChannels.child(currentUid).child(chatPartner.uid).setValue([channelId: true])
            FirebaseConstants.UserDirectionChannels.child(chatPartner.uid).child(currentUid).setValue([channelId: true])
        }
        
        var newChannelItem = ChannelItem(channelDict)
        newChannelItem.members = selectedChatPartners
        return .success(newChannelItem)
    }
    
}
