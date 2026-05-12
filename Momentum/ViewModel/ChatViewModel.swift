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
    
    // Όταν δημιουργείται το ViewModel, του λέμε ποιο chat να "ακούει"
    init(chatId: String) {
        self.chatId = chatId
        listenForMessages()
        markAsRead()
    }
    
    // 1. Διάβασμα μηνυμάτων σε πραγματικό χρόνο
    func listenForMessages() {
        db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp", descending: false) // Ταξινόμηση βάσει ώρας
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                // Μετατροπή των εγγράφων σε Message objects
                self.messages = documents.compactMap({ try? $0.data(as: Message.self) })
            }
    }
    
    func markAsRead() {
        // Ενημερώνουμε το κεντρικό έγγραφο του chat ότι διαβάστηκε
        Firestore.firestore().collection("chats").document(chatId).updateData([
            "isRead": true
        ])
    }
    
    func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // 1. Δεδομένα για το μήνυμα
        let messageData: [String: Any] = [
            "text": messageText,
            "senderId": currentUid,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        // 2. Δεδομένα για το "μεγάλο κουτί" (το Chat Document)
        // Χωρίζουμε το chatId για να βρούμε τους δύο συμμετέχοντες
        let participantIds = chatId.components(separatedBy: "_")
        
        let chatData: [String: Any] = [
            "lastMessage": messageText,
            "timestamp": FieldValue.serverTimestamp(),
            "participants": participantIds,
            "lastSenderId": currentUid, // Αποθηκεύουμε ποιος έστειλε το τελευταίο μήνυμα
            "isRead": false // Το νέο μήνυμα είναι πάντα αδιάβαστο στην αρχή
        ]
        
        // 3. Σώζουμε ΠΡΩΤΑ το μεγάλο κουτί και ΜΕΤΑ το μήνυμα
        let chatRef = db.collection("chats").document(chatId)
        
        chatRef.setData(chatData, merge: true) { error in
            if let error = error {
                print("Error saving chat: \(error)")
                return
            }
            
            // Τώρα σώζουμε το μήνυμα στη sub-collection
            chatRef.collection("messages").addDocument(data: messageData) { _ in
                DispatchQueue.main.async {
                    self.messageText = ""
                }
            }
        }
    }
}
