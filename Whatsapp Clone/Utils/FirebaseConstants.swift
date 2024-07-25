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
}
