//
//  MessageItem.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 23/07/24.
//

import SwiftUI

struct MessageItem: Identifiable {
    let id = UUID().uuidString
    let text: String
    let direction: MessageDirection
    let type: MessageType
    
    static let sentPlaceholder = MessageItem(text: "Check cehck", direction: .sent, type: .text)
    static let receivedPlaceholder = MessageItem(text: "Check cehck", direction: .received, type: .text)
    
    var alignment: Alignment {
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment: HorizontalAlignment {
        return direction == .received ? .leading : .trailing
    }
    
    var backgroundColor: Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    
    static let stubMessage: [MessageItem] = [
        MessageItem(text: "Hi there", direction: .sent, type: .text),
        MessageItem(text: "Check out this photo", direction: .received, type: .photo),
        MessageItem(text: "Play out this video", direction: .sent, type: .video)
    ]
}

enum MessageType {
    case text, photo, video
}

enum MessageDirection {
    case sent, received
    
    static var random: MessageDirection {
        return [MessageDirection.sent, .received].randomElement() ?? .sent
    }
}