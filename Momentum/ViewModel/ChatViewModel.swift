//
//  ChatViewModel.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 9/5/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine


class ChatViewModel: ObservableObject {
    @Published var messages = [Message]()
    @Published var messageText = "" // Για το TextField σου
    
    let chatId: String
    private let db = Firestore.firestore()
    

    init(chatId: String) {
        self.chatId = chatId
        listenForMessages()
        markAsRead()
    }
    

    func listenForMessages() {
        db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                

                self.messages = documents.compactMap({ try? $0.data(as: Message.self) })
            }
    }
    
    func markAsRead() {
        Firestore.firestore().collection("chats").document(chatId).updateData([
            "isRead": true
        ])
    }
    
    func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        

        let messageData: [String: Any] = [
            "text": messageText,
            "senderId": currentUid,
            "timestamp": FieldValue.serverTimestamp()
        ]
        

        let participantIds = chatId.components(separatedBy: "_")
        
        let chatData: [String: Any] = [
            "lastMessage": messageText,
            "timestamp": FieldValue.serverTimestamp(),
            "participants": participantIds,
            "lastSenderId": currentUid,
            "isRead": false
        ]

        let chatRef = db.collection("chats").document(chatId)
        
        chatRef.setData(chatData, merge: true) { error in
            if let error = error {
                print("Error saving chat: \(error)")
                return
            }
            
            chatRef.collection("messages").addDocument(data: messageData) { _ in
                DispatchQueue.main.async {
                    self.messageText = ""
                }
            }
        }
    }
}
