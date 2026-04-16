//
//  HabitCardView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 1/4/26.
//

import SwiftUI

struct HabitsCardView: View {
    
    let habit: Habit
    
    let onToggle: () -> Void
    
    var body: some View {

            HStack {
                Text(habit.title)
                    .foregroundColor(.white)
                    .lineLimit(1)
                Image(systemName: habit.icon)
                    .foregroundColor(.white)
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .semibold))
                    .opacity(habit.isSelected ? 1: 0)
                    .symbolRenderingMode(.monochrome)
                    .symbolEffect(.bounce.wholeSymbol, value: habit.isSelected)
                    .foregroundColor(.white)
                
                
            }
            .cornerRadius(20)
            .padding()
            .background(Color.white.opacity(0.07))
            .animation(.easeInOut(duration: 0.25), value: habit.isSelected)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(habit.isSelected ? Color.purple : Color.white.opacity(0.07), lineWidth: 2)
            )
            .cornerRadius(20)
            .fixedSize(horizontal: true, vertical: false)
            .onTapGesture {
                onToggle()
            }
            .frame(maxWidth: .infinity)
        }
    
}

#Preview {
    HabitsCardView(habit: Habit(title: "Tennis", isSelected: true, icon: "tennis.racket"), onToggle: {})
}
