//
//  MessageItem+Types.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 31/07/24.
//

import Foundation

enum AdminMessageType: String {
    case channelCreation
    case memberAdded
    case memberLeft
    case channelNameChanged
}

enum MessageType {
    case text, photo, video, audio
}

enum MessageDirection {
    case sent, received
    
    static var random: MessageDirection {
        return [MessageDirection.sent, .received].randomElement() ?? .sent
    }
}
