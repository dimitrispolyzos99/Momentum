//
//  ChatView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 9/5/26.
//

import SwiftUI

struct ChatView: View {

    @StateObject private var chatViewModel: ChatViewModel
    let chatId: String
    

    init(chatId: String) {
        self.chatId = chatId

        _chatViewModel = StateObject(wrappedValue: ChatViewModel(chatId: chatId))
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            RadialGradient(colors: [Color.purple.opacity(0.35), Color.clear], center: .top, startRadius: 0, endRadius: 300)
                .ignoresSafeArea()
            
            VStack {

                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(chatViewModel.messages) { message in
                                messageBubble(message: message)
                            }
                        }
                        .padding()
                    }

                    .onChange(of: chatViewModel.messages.count) { _ in
                        withAnimation {
                            proxy.scrollTo(chatViewModel.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                
                divider
                

                messageInputArea
            }
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


extension ChatView {
    
    private func messageBubble(message: Message) -> some View {
        HStack {
            if message.isFromCurrentUser { Spacer() }
            
            Text(message.text)
                .padding(12)
                .background(message.isFromCurrentUser ? Color.purple : Color.white.opacity(0.75))
                .foregroundColor(.black)
                .cornerRadius(16)
                .frame(maxWidth: 250, alignment: message.isFromCurrentUser ? .trailing : .leading)
            
            if !message.isFromCurrentUser { Spacer() }
        }
        .id(message.id)
    }
    
    private var messageInputArea: some View {
        HStack(spacing: 12) {
            // Προσοχή: το ονομάσαμε 'messageText' στο ChatViewModel προηγουμένως
            TextField("Type a message...", text: $chatViewModel.messageText)
                .padding(10)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(20)
                .foregroundColor(.white)
            
            Button {
                chatViewModel.sendMessage()
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.purple)
                    .font(.system(size: 22))
            }
            .disabled(chatViewModel.messageText.isEmpty)
        }
        .padding()
    }
    
    private var divider: some View {
        Rectangle()
            .frame(height: 0.5)
            .foregroundColor(.gray.opacity(0.3))
    }
}

#Preview {
    NavigationStack {
        ChatView(chatId: "preview_id")
    }
}
