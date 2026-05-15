//
//  MainMessageView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 12/5/26.
//

import SwiftUI
import FirebaseAuth

struct MainMessagesView: View {
    @StateObject var viewModel = MainMessagesViewModel()
    @State private var showNewMessageView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                RadialGradient(colors: [Color.purple.opacity(0.35), Color.clear], center: .top, startRadius: 0, endRadius: 300)
                    .ignoresSafeArea()
                
                List(viewModel.recentChats) { chat in
                    NavigationLink(destination: ChatView(chatId: chat.id ?? "")) {
                        recentChatRow(chat)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Messages")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewMessageView.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.purple)
                    }
                }
            }
            .sheet(isPresented: $showNewMessageView) {
                NewMessageView()
            }
        }
    }
    
    private func recentChatRow(_ chat: RecentChat) -> some View {
        HStack(spacing: 15) {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(chat.user?.fullname ?? "Loading...")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(chat.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()

            let currentUid = Auth.auth().currentUser?.uid ?? ""

            if chat.isRead == false && chat.lastSenderId != currentUid {
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.purple)
                    .shadow(color: .purple.opacity(0.5), radius: 4)
            }
        }
        .padding(.vertical, 8)

    }
}
