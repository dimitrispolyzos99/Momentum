//
//  Habit.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 31/3/26.
//

import Foundation
import SwiftData

@Model
class Habit {
    var title: String
    var isSelected: Bool
    var icon: String
    var userId: String
    
    init(title: String, isSelected: Bool, icon: String, userId: String) {
        self.title = title
        self.isSelected = isSelected
        self.icon = icon
        self.userId = userId
    }
}
