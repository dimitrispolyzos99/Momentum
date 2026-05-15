//
//  ChatService.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 9/5/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ChatService {
    private let db = Firestore.firestore()
    

    func sendMessage(text: String, chatId: String, senderId: String, receiverId: String) {
        let db = Firestore.firestore()
        let participants = [senderId, receiverId]
        

        db.collection("chats").document(chatId).setData([
            "participants": participants,
            "lastMessage": text,
            "timestamp": FieldValue.serverTimestamp()
        ], merge: true)
        

        let messageData: [String: Any] = [
            "text": text,
            "senderId": senderId,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        db.collection("chats").document(chatId).collection("messages").addDocument(data: messageData)
    }

    func listenForMessages(chatId: String, completion: @escaping ([Message]) -> Void) {
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp", descending: false) // Τα θέλουμε με τη σειρά που στάλθηκαν
            .addSnapshotListener { querySnapshot, error in
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                let messages = documents.compactMap { queryDocumentSnapshot -> Message? in
                    return try? queryDocumentSnapshot.data(as: Message.self)
                }
                
                completion(messages)
            }
    }
}
