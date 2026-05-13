//
//  PlayerProgress.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 31/3/26.
//

import Foundation
import SwiftData

@Model
class PlayerProgress {
    var level: Int
    var currentXP: Int
    var xpForNextLevel: Int
    var streak: Int
    var lastDailyReset: Date
    var didCompleteDailyGoal: Bool
    var userId: String
    
    init(level: Int, currentXP: Int, xpForNextLevel: Int, streak: Int, lastDailyReset: Date, didCompleteDailyGoal: Bool, userId: String) {
        self.level = level
        self.currentXP = currentXP
        self.xpForNextLevel = xpForNextLevel
        self.streak = streak
        self.lastDailyReset = lastDailyReset
        self.didCompleteDailyGoal = didCompleteDailyGoal
        self.userId = userId
    }
}
