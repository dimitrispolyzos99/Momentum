//
//  HomeViewModel.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 31/3/26.
//

import Foundation
import Combine
import SwiftData
import FirebaseAuth

class HomeViewModel: ObservableObject {
    @Published var didLevelUp = false
    @Published var dailyGoal = false

    // MARK: - Seed & Missions

    func seedHabits(context: ModelContext, userId: String) {
        let defaults = [
            Habit(title: "Workout", isSelected: false, icon: "figure.strengthtraining.traditional", userId: userId),
            Habit(title: "Read", isSelected: false, icon: "book", userId: userId),
            Habit(title: "Drink Water", isSelected: false, icon: "drop", userId: userId),
            Habit(title: "Walk", isSelected: false, icon: "figure.walk", userId: userId),
            Habit(title: "Meditate", isSelected: false, icon: "brain", userId: userId),
            Habit(title: "Journal", isSelected: false, icon: "square.and.pencil", userId: userId),
            Habit(title: "Stretch", isSelected: false, icon: "figure.cooldown", userId: userId),
            Habit(title: "Sleep Early", isSelected: false, icon: "bed.double", userId: userId),
            Habit(title: "Study Swift", isSelected: true, icon: "laptopcomputer", userId: userId),
            Habit(title: "No Sugar", isSelected: false, icon: "leaf", userId: userId),
        ]
        for habit in defaults { context.insert(habit) }
    }

    func assignDailyMissions(context: ModelContext, habits: [Habit], missions: [Mission], progress: PlayerProgress?, userId: String) {
        let today = missions.filter {
            Calendar.current.isDateInToday($0.assignedDate) && $0.userId == userId
        }
        guard today.isEmpty else { return }

        let streak = progress?.streak ?? 0
        let tier = min(streak / 3, 2)
        let selectedHabits = habits.filter { $0.isSelected && $0.userId == userId }
        let selectedHabitTitles = selectedHabits.map { $0.title }

        let habitTemplates = MissionTemplate.all
            .filter { template in
                guard let habitTitle = template.habitTitle else { return false }
                return selectedHabitTitles.contains(habitTitle)
            }
            .shuffled().prefix(5)

        var picked = Array(habitTemplates)

        if picked.count < 5 {
            let generalTemplates = MissionTemplate.all
                .filter { $0.habitTitle == nil }
                .shuffled().prefix(5 - picked.count)
            picked += generalTemplates
        }

        for template in picked {
            let habit = selectedHabits.first { $0.title == template.habitTitle }
            let mission = Mission(
                title: template.title(for: tier),
                rewardXP: template.xp(for: tier),
                difficulty: tier + 1,
                isCompleted: false,
                relatedHabit: habit,
                userId: userId
            )
            context.insert(mission)
        }
    }
    func completeMission(_ mission: Mission, progress: PlayerProgress, missions: [Mission]) {
        mission.isCompleted.toggle()
        
        let xpChange = mission.isCompleted ? mission.rewardXP : -mission.rewardXP
        applyXPChange(amount: xpChange, progress: progress)
        
        let completedCount = missions.filter { $0.isCompleted }.count
        
        if completedCount >= 3 && !progress.didCompleteDailyGoal {
            progress.didCompleteDailyGoal = true
            progress.streak += 1
            dailyGoal = true
            applyXPChange(amount: 150, progress: progress)
        }
    }
    
    private func applyXPChange(amount: Int, progress: PlayerProgress) {
        progress.currentXP += amount
        
        if progress.currentXP < 0 && progress.level == 1 {
            progress.currentXP = 0
        }
        
        recalculateProgress(progress: progress)
    }
    
    private func recalculateProgress(progress: PlayerProgress) {
        while progress.currentXP >= progress.xpForNextLevel {
            progress.currentXP -= progress.xpForNextLevel
            progress.level += 1
            progress.xpForNextLevel += 100
            didLevelUp = true
        }
        
        if progress.currentXP < 0 && progress.level > 1 {
            progress.level -= 1
            progress.xpForNextLevel -= 100
            progress.currentXP += progress.xpForNextLevel
        }
        
        if progress.currentXP < 0 {
            progress.currentXP = 0
        }
    }
    
    func checkDailyReset(missions: [Mission], progress: PlayerProgress) {
        let calendar = Calendar.current
        
        if calendar.isDate(progress.lastDailyReset, inSameDayAs: Date()) {
            return
        }
        
        if !progress.didCompleteDailyGoal {
            progress.streak = 0
        }
        
        for mission in missions {
            mission.isCompleted = false
        }
        
        progress.didCompleteDailyGoal = false
        progress.lastDailyReset = Date()
    }
}
