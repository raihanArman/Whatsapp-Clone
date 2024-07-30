//
//  ChannelItem.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 30/07/24.
//

import Foundation

struct ChannelItem: Identifiable {
    var id: String
    var name: String?
    var lastMessage: String
    var creationDate: Date
    var lastMessageTimeStamp: Date
    var membersCount: UInt
    var adminUids: [String]
    var memberUids: [String]
    var members: [UserItem]
    var thumbnailUrl: String?
    
    var isGroupChat: Bool {
        return membersCount > 2
    }
}
