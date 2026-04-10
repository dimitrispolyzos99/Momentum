//
//  HabitView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 6/4/26.
//

import SwiftUI
import SwiftData

struct HabitsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]

    @State private var isShowingAddHabit = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            RadialGradient(colors: [Color.purple.opacity(0.35), Color.clear], center: .top, startRadius: 0, endRadius: 300)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Add habits to your routine")
                        .font(.subheadline)
                        .foregroundColor(.white)

                    ForEach(habits) { habit in
                        HabitsCardView(
                            habit: habit,
                            onToggle: {
                                habit.isSelected.toggle()
                            }
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Habits")
        .toolbar {
            Button {
                isShowingAddHabit = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $isShowingAddHabit) {
            AddHabitView { title in
                let newHabit = Habit(
                    title: title,
                    isSelected: true,
                    icon: "Checkmark.circle"
                )
                modelContext.insert(newHabit)
            }
        }
        .onAppear {
            if habits.isEmpty {
                seedHabits()
            }
        }
    }

    private func seedHabits() {
        let defaults = [
            Habit(title: "Workout", isSelected: false, icon: "figure.walk"),
            Habit(title: "Read", isSelected: false, icon: "book"),
            Habit(title: "Cook", isSelected: false, icon: "pizza"),
            Habit(title: "Drink water", isSelected: true, icon: "brain")
        ]
        for habit in defaults {
            modelContext.insert(habit)
        }
    }
}

#Preview {
    NavigationStack {
        HabitsView()
    }
}
