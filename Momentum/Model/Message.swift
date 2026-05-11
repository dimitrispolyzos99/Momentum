//
//  Message.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 9/5/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Message: Identifiable, Codable {
    @DocumentID var id: String? // Το ID που δίνει αυτόματα το Firestore
    let senderId: String        // Το UID του χρήστη που το έστειλε
    let text: String            // Το περιεχόμενο
    @ServerTimestamp var timestamp: Date? // Η ώρα από τον server (όχι από το κινητό!)
    
    // Helper property για να ξέρουμε αν το μήνυμα είναι δικό μας
    var isFromCurrentUser: Bool {
        return senderId == Auth.auth().currentUser?.uid
    }
}
