//
//  Mission.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 31/3/26.
//

import Foundation
import SwiftData

@Model
class Mission {
    var title: String
    var rewardXP: Int
    var difficulty: Int
    var isCompleted: Bool
    var assignedDate: Date
    var relatedHabit: Habit?
    var userId: String
    
    init(title: String, rewardXP: Int, difficulty: Int, isCompleted: Bool, relatedHabit: Habit? = nil, userId: String) {
        self.title = title
        self.rewardXP = rewardXP
        self.difficulty = difficulty
        self.isCompleted = isCompleted
        self.assignedDate = Date()
        self.relatedHabit = relatedHabit
        self.userId = userId
    }
}
