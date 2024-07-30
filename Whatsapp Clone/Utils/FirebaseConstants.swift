//
//  FirebaseConstants.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 25/07/24.
//

import Foundation
import Firebase
import FirebaseStorage

enum FirebaseConstants {
    private static let DatabaseRef = Database.database().reference()
    static let UserRef = DatabaseRef.child("users")
    static let ChannelRef = DatabaseRef.child("channels")
    static let MessageRef = DatabaseRef.child("channel-messages")
    static let UserChannelRef = DatabaseRef.child("user-channels")
    static let UserDirectionChannels = DatabaseRef.child("user-direct-channels")
}
