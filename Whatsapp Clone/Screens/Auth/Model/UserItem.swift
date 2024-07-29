//
//  UserItem.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 25/07/24.
//

import Foundation

struct UserItem: Identifiable, Hashable, Decodable {
    let uid: String
    let username: String
    let email: String
    var bio: String? = nil
    var profileImageUrl: String? = nil
    
    var id: String {
        return uid
    }
    
    var bioUnwrapped: String {
        return bio ?? "Hey there! I am using Whatsapp"
    }
}

extension UserItem {
    init(dictionary: [String: Any]) {
        self.uid = dictionary[.uid] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.bio = dictionary[.bio] as? String ?? nil
        self.profileImageUrl = dictionary[.profileImageUrl] as? String ?? nil
    }
    
    static let placeholder = UserItem(uid: "Check", username: "Ampas kuda", email: "ampaskuda@gmail.com")
    
    static let placeholders: [UserItem] = [
        UserItem(uid: "1", username: "Kevin", email: "kevin@gmail.com"),
        UserItem(uid: "2", username: "Ampas", email: "ampas@gmail.com"),
        UserItem(uid: "3", username: "Kuda", email: "kuda@gmail.com"),
        UserItem(uid: "4", username: "Lingard", email: "lingard@gmail.com"),
        UserItem(uid: "5", username: "Pogba", email: "pogba@gmail.com"),
    ]
}

extension String {
    static let uid = "uid"
    static let username = "username"
    static let email = "email"
    static let bio = "bio"
    static let profileImageUrl = "profileImageUrl"
}
