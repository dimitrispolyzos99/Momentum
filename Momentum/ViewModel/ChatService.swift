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
    
    // 1. Αποστολή Μηνύματος
    func sendMessage(text: String, chatId: String, senderId: String, receiverId: String) {
        let db = Firestore.firestore()
        
        // 1. Λίστα συμμετεχόντων
        let participants = [senderId, receiverId]
        
        // 2. Ενημερώνουμε (ή δημιουργούμε) το κεντρικό έγγραφο του chat
        // Χρησιμοποιούμε setData με merge: true για να μη σβήνει τα παλιά
        db.collection("chats").document(chatId).setData([
            "participants": participants,
            "lastMessage": text,
            "timestamp": FieldValue.serverTimestamp()
        ], merge: true)
        
        // 3. Μετά αποθηκεύουμε το μήνυμα στη sub-collection (όπως το είχες)
        let messageData: [String: Any] = [
            "text": text,
            "senderId": senderId,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        db.collection("chats").document(chatId).collection("messages").addDocument(data: messageData)
    }
    // 2. Real-time Λήψη Μηνυμάτων
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
                
                // Μετατροπή των Firebase documents σε [Message] objects αυτόματα λόγω Codable
                let messages = documents.compactMap { queryDocumentSnapshot -> Message? in
                    return try? queryDocumentSnapshot.data(as: Message.self)
                }
                
                completion(messages)
            }
    }
}
