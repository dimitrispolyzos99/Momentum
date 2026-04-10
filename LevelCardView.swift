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
        VStack(alignment: .leading, spacing: 8){
            HStack{
                Text("Level \(progress.level)")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Text("Streak: \(progress.streak) 🔥")
                    .font(.footnote)
                    .foregroundColor(.white)
            }
                Text("Current xp \(progress.currentXP)/\(progress.xpForNextLevel)")
                .font(.subheadline)
                .foregroundColor(.white)
            ProgressView(value: Double(progress.currentXP), total: Double(progress.xpForNextLevel))
                .animation(.easeInOut(duration: 0.4), value: progress.currentXP)
                .tint(.green)
                .scaleEffect(x:1, y: 2, anchor: .center)

                
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.purple, lineWidth: 2)
            )
            .background(LinearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding()


    }
}

#Preview {
    LevelCardView(progress: PlayerProgress(level: 1, currentXP: 50, xpForNextLevel: 100, streak: 1))
}
