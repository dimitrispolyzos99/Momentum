//
//  HomeViewModel.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 31/3/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var playerProgress: PlayerProgress

    init() {
        self.playerProgress = PlayerProgress(level: 1, currentXP: 0, xpForNextLevel: 100, streak: 0, lastDailyReset: Date(), didCompleteDailyGoal: false)
    }

    func completeMission(_ mission: Mission, missions :[Mission]) {
        mission.isCompleted.toggle()

        let xpChange = mission.isCompleted ? mission.rewardXP : -mission.rewardXP
        applyXPChange(amount: xpChange)
        
        let completedCount = missions.filter { $0.isCompleted }.count
        
        if completedCount >= 3 && !playerProgress.didCompleteDailyGoal {
            playerProgress.didCompleteDailyGoal = true
            playerProgress.streak += 1
            
            applyXPChange(amount: 150)
        }

    }

    private func applyXPChange(amount: Int) {
        playerProgress.currentXP += amount

        if playerProgress.currentXP < 0 && playerProgress.level == 1 {
            playerProgress.currentXP = 0
        }

        recalculateProgress()
    }

    private func recalculateProgress() {
        while playerProgress.currentXP >= playerProgress.xpForNextLevel {
            playerProgress.currentXP -= playerProgress.xpForNextLevel
            playerProgress.level += 1
            playerProgress.xpForNextLevel += 100
        }

        if playerProgress.currentXP < 0 && playerProgress.level > 1 {
            playerProgress.level -= 1
            playerProgress.xpForNextLevel -= 100
            playerProgress.currentXP += playerProgress.xpForNextLevel
        }

        if playerProgress.currentXP < 0 {
            playerProgress.currentXP = 0
        }
    }
    func checkDailyReset(missions: [Mission]) {
        let calendar = Calendar.current

        if calendar.isDate(playerProgress.lastDailyReset, inSameDayAs: Date()) {
            return
        }

        if !playerProgress.didCompleteDailyGoal {
            playerProgress.streak = 0
        }

        for mission in missions {
            mission.isCompleted = false
        }

        playerProgress.didCompleteDailyGoal = false
        playerProgress.lastDailyReset = Date()
    }}
