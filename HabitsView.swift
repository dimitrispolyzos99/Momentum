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
    @Query private var missions: [Mission]
    
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
            if missions.isEmpty {
                seedMissions()
            }
        }
    }
    
    private func seedHabits() {
        let defaults = [
            Habit(title: "Workout", isSelected: false, icon: "figure.strengthtraining.traditional"),
            Habit(title: "Read", isSelected: false, icon: "book"),
            Habit(title: "Drink Water", isSelected: true, icon: "drop"),
            Habit(title: "Walk", isSelected: false, icon: "figure.walk"),
            Habit(title: "Meditate", isSelected: false, icon: "brain"),
            Habit(title: "Journal", isSelected: false, icon: "square.and.pencil"),
            Habit(title: "Stretch", isSelected: false, icon: "figure.cooldown"),
            Habit(title: "Sleep Early", isSelected: false, icon: "bed.double"),
            Habit(title: "Study Swift", isSelected: true, icon: "laptopcomputer"),
            Habit(title: "No Sugar", isSelected: false, icon: "leaf")
        ]
        
        for habit in defaults {
            modelContext.insert(habit)
        }
    }
    private func seedMissions() {
        let workoutHabit = habits.first { $0.title == "Workout" }
        let readHabit = habits.first { $0.title == "Read" }
        let waterHabit = habits.first { $0.title == "Drink Water" }
        let walkHabit = habits.first { $0.title == "Walk" }
        let meditateHabit = habits.first { $0.title == "Meditate" }
        let journalHabit = habits.first { $0.title == "Journal" }
        let stretchHabit = habits.first { $0.title == "Stretch" }
        let sleepHabit = habits.first { $0.title == "Sleep Early" }
        let swiftHabit = habits.first { $0.title == "Study Swift" }
        let noSugarHabit = habits.first { $0.title == "No Sugar" }
        
        let defaults = [
            // General missions
            Mission(title: "Drink 3 bottles of water today", rewardXP: 120, difficulty: 2, isCompleted: false, relatedHabit: nil),
            Mission(title: "Help a stranger", rewardXP: 100, difficulty: 2, isCompleted: false, relatedHabit: nil),
            Mission(title: "Stay focused for 30 minutes", rewardXP: 70, difficulty: 1, isCompleted: false, relatedHabit: nil),
            Mission(title: "Take a 10 minute walk", rewardXP: 60, difficulty: 1, isCompleted: false, relatedHabit: nil),
            
            // Habit-linked missions
            Mission(title: "Workout 20 minutes", rewardXP: 110, difficulty: 2, isCompleted: false, relatedHabit: workoutHabit),
            Mission(title: "Read 10 pages", rewardXP: 80, difficulty: 1, isCompleted: false, relatedHabit: readHabit),
            Mission(title: "Drink 2 more glasses of water", rewardXP: 55, difficulty: 1, isCompleted: false, relatedHabit: waterHabit),
            Mission(title: "Walk 15 minutes", rewardXP: 70, difficulty: 1, isCompleted: false, relatedHabit: walkHabit),
            Mission(title: "Meditate for 5 minutes", rewardXP: 75, difficulty: 1, isCompleted: false, relatedHabit: meditateHabit),
            Mission(title: "Write 3 journal lines", rewardXP: 65, difficulty: 1, isCompleted: false, relatedHabit: journalHabit),
            Mission(title: "Stretch for 5", rewardXP: 50, difficulty: 1, isCompleted: false, relatedHabit: stretchHabit),
            Mission(title: "Sleep before 11 PM", rewardXP: 90, difficulty: 2, isCompleted: false, relatedHabit: sleepHabit),
            Mission(title: "Study Swift for 20 minutes", rewardXP: 120, difficulty: 2, isCompleted: false, relatedHabit: swiftHabit),
            Mission(title: "Avoid sugar today", rewardXP: 100, difficulty: 2, isCompleted: false, relatedHabit: noSugarHabit)
        ]
        
        for mission in defaults {
            modelContext.insert(mission)
        }
    }
}

#Preview {
    NavigationStack {
        HabitsView()
    }
}
