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
            // Swipe background
            if offset > 0 {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .opacity(Double(min(offset / 80.0, 1.0)))
                        .padding(.leading, 24)
                    Spacer()
                }
            }

            HStack(spacing: 14) {
                // Left accent
                RoundedRectangle(cornerRadius: 3)
                    .fill(mission.isCompleted ? Color.purple.opacity(0.4) : Color.purple)
                    .frame(width: 4)

                VStack(alignment: .leading, spacing: 5) {
                    Text(mission.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(mission.isCompleted ? .white.opacity(0.4) : .white)
                        .strikethrough(mission.isCompleted, color: .white.opacity(0.4))

                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .font(.caption2)
                            .foregroundColor(mission.isCompleted ? .gray : .yellow)
                        Text("\(mission.rewardXP) XP")
                            .font(.caption)
                            .foregroundColor(mission.isCompleted ? .gray : .yellow)
                    }
                }

                Spacer()

                Image(systemName: mission.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(mission.isCompleted ? .purple : .white.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(mission.isCompleted ? Color.purple.opacity(0.15) : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                mission.isCompleted ? Color.purple.opacity(0.3) : Color.white.opacity(0.1),
                                lineWidth: 1
                            )
                    )
            )
            .offset(x: offset)
            .scaleEffect(offset > 0 ? 0.98 : 1.0)
            .animation(.spring(response: 0.3), value: offset)
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
