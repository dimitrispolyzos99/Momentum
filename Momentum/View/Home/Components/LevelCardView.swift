//
//  LevelCardView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 1/4/26.
//

import SwiftUI

struct LevelCardView: View {
    let progress: PlayerProgress
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Level \(progress.level)")
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(.white)
                    Text("Keep pushing, warrior 🗡️")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("🔥 \(progress.streak)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.orange)
                    Text("day streak")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Spacer().frame(height: 4)
            
            HStack {
                Text("\(progress.currentXP) XP")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                Text("\(progress.xpForNextLevel) XP")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 10)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: geo.size.width * CGFloat(progress.currentXP) / CGFloat(progress.xpForNextLevel),
                            height: 10
                        )
                        .animation(.easeInOut(duration: 0.5), value: progress.currentXP)
                    }
                }
            .frame(height: 10)
        }
        .padding(20)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.black.opacity(0.4))
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [.purple, .pink.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
        )
        .padding(.horizontal)
    }
}
