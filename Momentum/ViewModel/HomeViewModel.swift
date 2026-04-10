//
//  HomeViewModel.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 31/3/26.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {

    @Published var habits: [Habit]
    @Published var playerProgress: PlayerProgress
    @Published var missions: [Mission]

    init() {
        self.playerProgress = PlayerProgress(level: 1, currentXP: 0, xpForNextLevel: 100, streak: 0)

        let habit1 = Habit(title: "Tennis", isSelected: true, icon: "tennis.racket")
        let habit2 = Habit(title: "Video Games", isSelected: false, icon: "gamecontroller")

        let mission1 = Mission(title: "Drink Water", rewardXP: 50, difficulty: 1, isCompleted: false)
        let mission2 = Mission(title: "Complete God of War", rewardXP: 200, difficulty: 2, isCompleted: false , relatedHabit: habit2)
        let mission3 = Mission(title: "Read a book", rewardXP: 250, difficulty: 1, isCompleted: false)
        let mission4 = Mission(title: "Complete The Witcher", rewardXP: 300, difficulty: 3, isCompleted: false)

        self.habits = [habit1, habit2]
        self.missions = [mission1, mission2, mission3, mission4]
    }

    func toggleHabitdSelection(_ habit: Habit) {
        if let index = self.habits.firstIndex(of: habit) {
            let updatedHabit = self.habits[index]
            updatedHabit.isSelected.toggle()
            self.habits[index] = updatedHabit
        }
    }

    func completeMission(_ mission: Mission) {
        guard let index = missions.firstIndex(where: { $0.id == mission.id }) else { return }

        let updated = mission
        updated.isCompleted.toggle()
        missions[index] = updated

        let xpChange = updated.isCompleted ? mission.rewardXP : -mission.rewardXP
        applyXPChange(amount: xpChange)
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
    func addHabit(title: String) {
        let newHabit = Habit(
            title: title,
            isSelected: false,
            icon: "circle"
        )
        
        habits.append(newHabit)
    }
}

