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
    
    // 2. Αποστολή μηνύματος
    func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let messageData: [String: Any] = [
            "text": messageText,
            "senderId": currentUid,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        // Προσθήκη του μηνύματος στη sub-collection του συγκεκριμένου chat
        db.collection("chats").document(chatId).collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("DEBUG: Σφάλμα αποστολής: \(error.localizedDescription)")
            } else {
                // Καθαρίζουμε το TextField μετά την αποστολή
                DispatchQueue.main.async {
                    self.messageText = ""
                }
            }
        }
    }
}
