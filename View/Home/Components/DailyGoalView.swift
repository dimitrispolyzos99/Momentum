//
//  DailyGoalView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 15/4/26.
//

import SwiftUI

struct DailyGoalView: View {
    let onDismiss: () -> Void

    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 20) {
                Text("🔥")
                    .font(.system(size: 80))

                Text("ON FIRE!")
                    .font(.system(size: 40, weight: .black))
                    .foregroundColor(.orange)

                Text("3 missions completed!\n+150 bonus XP")
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Button("Keep going!") {
                    onDismiss()
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 14)
                .background(Color.orange)
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
    DailyGoalView(onDismiss: {})
}
