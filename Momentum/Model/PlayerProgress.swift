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
    
    init(level: Int, currentXP: Int, xpForNextLevel: Int, streak: Int, lastDailyReset: Date, didCompleteDailyGoal: Bool) {
        self.level = level
        self.currentXP = currentXP
        self.xpForNextLevel = xpForNextLevel
        self.streak = streak
        self.lastDailyReset = lastDailyReset
        self.didCompleteDailyGoal = didCompleteDailyGoal
    }
}
