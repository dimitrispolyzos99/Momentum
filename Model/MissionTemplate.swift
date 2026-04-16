//
//  MissionTemplate.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 16/4/26.
//

import Foundation

struct MissionTemplate {
    let baseTitle: String
    let baseValue: Int  
    let unit: String
    let baseXP: Int
    let habitTitle: String?
    
    func title(for tier: Int) -> String {
        let scaled = Int(Double(baseValue) * pow(1.2, Double(tier)))
        return "\(baseTitle) \(scaled) \(unit)"
    }
    
    func xp(for tier: Int) -> Int {
        return Int(Double(baseXP) * pow(1.2, Double(tier)))
    }
}

extension MissionTemplate {
    static let all: [MissionTemplate] = [
        // Habit-linked
        MissionTemplate(baseTitle: "Workout", baseValue: 20, unit: "minutes", baseXP: 110, habitTitle: "Workout"),
        MissionTemplate(baseTitle: "Read", baseValue: 10, unit: "pages", baseXP: 80, habitTitle: "Read"),
        MissionTemplate(baseTitle: "Drink", baseValue: 2, unit: "glasses of water", baseXP: 55, habitTitle: "Drink Water"),
        MissionTemplate(baseTitle: "Walk", baseValue: 15, unit: "minutes", baseXP: 70, habitTitle: "Walk"),
        MissionTemplate(baseTitle: "Meditate for", baseValue: 5, unit: "minutes", baseXP: 75, habitTitle: "Meditate"),
        MissionTemplate(baseTitle: "Journal for", baseValue: 10, unit: "minutes", baseXP: 65, habitTitle: "Journal"),
        MissionTemplate(baseTitle: "Stretch for", baseValue: 5, unit: "minutes", baseXP: 50, habitTitle: "Stretch"),
        MissionTemplate(baseTitle: "Study Swift for", baseValue: 20, unit: "minutes", baseXP: 120, habitTitle: "Study Swift"),
        
        // General
        MissionTemplate(baseTitle: "Walk", baseValue: 10, unit: "minutes", baseXP: 60, habitTitle: nil),
        MissionTemplate(baseTitle: "Stay focused for", baseValue: 30, unit: "minutes", baseXP: 70, habitTitle: nil),
        MissionTemplate(baseTitle: "Drink", baseValue: 3, unit: "bottles of water", baseXP: 120, habitTitle: nil),
        MissionTemplate(baseTitle: "Read", baseValue: 5, unit: "pages", baseXP: 60, habitTitle: nil),
    ]
}
