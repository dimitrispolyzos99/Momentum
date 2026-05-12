//
//  RecentChat.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 12/5/26.
//

import Foundation
import FirebaseFirestore

struct RecentChat: Identifiable, Codable {
    @DocumentID var id: String?
    let lastMessage: String
    let participants: [String]
    let timestamp: Date
    let lastSenderId: String // Προσθέτουμε αυτό για να ξέρουμε ΠΟΙΟΣ το έστειλε
    var isRead: Bool // Η κατάσταση του μηνύματος
    var user: User?
}
