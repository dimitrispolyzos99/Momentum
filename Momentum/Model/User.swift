//
//  User.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 11/5/26.
//

import Foundation
import FirebaseFirestore


struct User: Identifiable, Codable, Sendable {
    @DocumentID var id: String? // Αυτό παίρνει αυτόματα το ID του εγγράφου
    let uid: String
    let fullname: String
    let email: String
    let profileImageUrl: String?
}
