//
//  PlayerProgress.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 31/3/26.
//

import Foundation


struct PlayerProgress {
    var level: Int
    var currentXP: Int
    var xpForNextLevel: Int
    var streak: Int
    var lastDailyReset: Date
    var didCompleteDailyGoal: Bool
}
