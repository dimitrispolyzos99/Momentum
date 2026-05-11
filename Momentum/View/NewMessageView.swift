//
//  NewMessageView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 11/5/26.
//

import SwiftUI
import FirebaseAuth

struct NewMessageView: View {
    @StateObject var viewModel = NewMessageViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            RadialGradient(colors: [Color.purple.opacity(0.35), Color.clear], center: .top, startRadius: 0, endRadius: 300)
                .ignoresSafeArea()
            NavigationStack {
                List(viewModel.users) { user in // <--- Εδώ χρησιμοποιούμε το 'users'
                    NavigationLink {
                        ChatView(chatId: createChatId(with: user))
                    } label: {
                        Text(user.fullname)
                    }
                }
                .navigationTitle("New Message")
            }
        }
    }
    
    func createChatId(with user: User) -> String {
        let currentUserUid = Auth.auth().currentUser?.uid ?? ""
        let partnerUid = user.uid
        return [currentUserUid, partnerUid].sorted().joined(separator: "_")
    }
}
