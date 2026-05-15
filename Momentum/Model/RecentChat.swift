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
    let lastSenderId: String 
    var isRead: Bool
    var user: User?
}
