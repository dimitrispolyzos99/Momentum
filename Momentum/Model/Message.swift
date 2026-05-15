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
    @DocumentID var id: String?
    let senderId: String
    let text: String
    @ServerTimestamp var timestamp: Date?
    

    var isFromCurrentUser: Bool {
        return senderId == Auth.auth().currentUser?.uid
    }
}
