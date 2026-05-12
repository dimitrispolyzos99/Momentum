//
//  RecentChatViewModel.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 12/5/26.
//

import SwiftUI
import Firebase
import Combine
import FirebaseAuth
import FirebaseFirestore

@MainActor
class MainMessagesViewModel: ObservableObject {
    @Published var recentChats = [RecentChat]()
    private let db = Firestore.firestore()
    
    init() {
        fetchRecentChats()
    }
    
    func fetchRecentChats() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // Ακούμε τα chats που συμμετέχεις, ταξινομημένα από το Firebase βάσει timestamp
        db.collection("chats")
            .whereField("participants", arrayContains: currentUid)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                // Μετατρέπουμε τα έγγραφα σε RecentChat objects
                let chats = documents.compactMap { try? $0.data(as: RecentChat.self) }
                
                // Ταξινόμηση στη Swift για σιγουριά (πιο πρόσφατα πάνω)
                self.recentChats = chats.sorted(by: { $0.timestamp > $1.timestamp })
                
                // Για κάθε chat, τρέχουμε το fetchPartnerUser για να βρούμε το όνομα
                for (index, chat) in self.recentChats.enumerated() {
                    if let partnerId = chat.participants.filter({ $0 != currentUid }).first {
                        self.fetchPartnerUser(uid: partnerId) { user in
                            DispatchQueue.main.async {
                                self.recentChats[index].user = user
                            }
                        }
                    }
                }
            }
    }

    func fetchPartnerUser(uid: String, completion: @escaping (User) -> Void) {
        // Πηγαίνουμε στο collection "users" και ψάχνουμε το έγγραφο με το συγκεκριμένο UID
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completion(user)
        }
    }
}
