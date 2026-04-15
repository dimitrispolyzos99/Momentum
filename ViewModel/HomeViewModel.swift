//
//  HomeViewModel.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 31/3/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var didLevelUp = false
    @Published var dailyGoal = false
    
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
