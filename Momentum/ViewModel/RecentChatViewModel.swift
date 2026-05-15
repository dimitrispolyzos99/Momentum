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
        

        db.collection("chats")
            .whereField("participants", arrayContains: currentUid)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                

                let chats = documents.compactMap { try? $0.data(as: RecentChat.self) }
                

                self.recentChats = chats.sorted(by: { $0.timestamp > $1.timestamp })
                

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
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completion(user)
        }
    }
}
