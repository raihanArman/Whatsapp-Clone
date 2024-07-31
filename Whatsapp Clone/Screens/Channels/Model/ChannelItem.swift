//
//  ChannelItem.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 30/07/24.
//

import Foundation
import FirebaseAuth

struct ChannelItem: Identifiable {
    var id: String
    var name: String?
    var lastMessage: String
    var creationDate: Date
    var lastMessageTimeStamp: Date
    var membersCount: Int
    var adminUids: [String]
    var memberUids: [String]
    var members: [UserItem]
    var thumbnailUrl: String?
    let createdBy: String
    
    var isGroupChat: Bool {
        return membersCount > 2
    }
    
    var memberExcludingMe: [UserItem] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return []}
        return members.filter { $0.uid != currentUid }
    }
    
    var title: String {
        if let name = name {
            return name
        }
        
        if isGroupChat {
            // Username 1 and username 2
            return groupMemberName
        } else {
            return memberExcludingMe.first?.username ?? ""
        }
    }
    
    private var groupMemberName: String {
        let memberCount = memberExcludingMe.count
        let fullName: [String] = memberExcludingMe.map { $0.username }
        
        if memberCount == 2 {
            // username 1 and username 2
            return fullName.joined(separator: " and ")
        } else if memberCount > 2 {
            let remainingCount = memberCount - 2
            return fullName.prefix(2).joined(separator: ", ") + ", and \(remainingCount) " + "others"
            // username1, username2 and other
        }
        
        return "Unknown"
    }
    
    static let placeholder = ChannelItem(id: "1", lastMessage: "Check check", creationDate: Date(), lastMessageTimeStamp: Date(), membersCount: 2, adminUids: [], memberUids: [], members: [], createdBy: "")
}

extension ChannelItem {
    init(_ dict: [String: Any]) {
        self.id = dict[.id] as? String ?? ""
        self.name = dict[.name] as? String? ?? nil
        self.lastMessage = dict[.lastMessage] as? String ?? ""
        let creationInterval = dict[.creationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: creationInterval)
        let lastMsgTimeStampInterval = dict[.lastMessageTimeStamp] as? Double ?? 0
        self.lastMessageTimeStamp = Date(timeIntervalSince1970: lastMsgTimeStampInterval)
        self.membersCount = dict[.membersCount] as? Int ?? 0
        self.adminUids = dict[.adminUids] as? [String] ?? []
        self.thumbnailUrl = dict[.thumbnailUrl] as? String ?? nil
        self.memberUids = dict[.memberUids] as? [String] ?? []
        self.members = dict[.members] as? [UserItem] ?? []
        self.createdBy = dict[.createdBy] as? String ?? ""
    }
}

extension String {
    static let id = "id"
    static let name = "name"
    static let lastMessage = "lastMessage"
    static let creationDate = "creationDate"
    static let lastMessageTimeStamp = "lastMessageTimeStamp"
    static let membersCount = "memberCount"
    static let adminUids = "adminUids"
    static let memberUids = "memberUids"
    static let members = "members"
    static let thumbnailUrl = "thumbnailUrl"
    static let createdBy = "createdBy"
}
