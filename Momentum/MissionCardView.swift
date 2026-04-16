//
//  QuestCardView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 1/4/26.
//

import SwiftUI

struct MissionCardView: View {
    let mission: Mission
    @State private var offset: CGFloat = 0

    let onToggle: () -> Void
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .fill(offset > 0 ? Color.purple.opacity(min(offset / 120.0, CGFloat(0.4))) : Color.clear)
            
            VStack(alignment: .leading, spacing: 8) {
                if !mission.isCompleted {
                    Text(mission.title)
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                    Text("Reward \(mission.rewardXP) xp").font(.subheadline).frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(.white)
                } else {
                    Text("\(mission.title) ✔ Completed")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("You earned \(mission.rewardXP) xp")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding()
            .background(
                mission.isCompleted ? Color.purple.opacity(0.3) : Color.white.opacity(0.07)
                )
            .cornerRadius(20)
            .offset(x: offset)
            .scaleEffect(offset > 0 ? 0.98 : 1.0)
            .animation(.spring(), value: offset)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.purple, lineWidth: 2)
            )
            .cornerRadius(20)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width > 0 {
                            offset = gesture.translation.width

                        }
                    }
                    .onEnded { _ in
                        if offset > 100 {
                            onToggle()
                        }
                        withAnimation(.spring()) {
                            offset = 0

                        }
                    }
            )
        }
        .padding(.horizontal)
    }
}

#Preview {
    MissionCardView(
        mission: Mission(title: "Read a chapter", rewardXP: 50, difficulty: 1, isCompleted: true),
        onToggle: {}
    )
}
