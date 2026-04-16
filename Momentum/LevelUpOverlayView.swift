//
//  LevelUpOverlayView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 14/4/26.
//

import SwiftUI


struct LevelUpOverlayView: View {
    let level: Int
    let onDismiss: () -> Void
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 20) {
                Text("⚡️")
                    .font(.system(size: 80))

                Text("LEVEL UP!")
                    .font(.system(size: 40, weight: .black))
                    .foregroundColor(.purple)

                Text("You reached Level \(level)")
                    .font(.title2)
                    .foregroundColor(.white)

                Button("Let's go!") {
                    onDismiss()
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 14)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(20)
                .font(.headline)
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
    }
}
#Preview {
    LevelUpOverlayView(level: 1, onDismiss: {})
}
