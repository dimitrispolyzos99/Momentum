//
//  MomentumApp.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 31/3/26.
//

import SwiftUI
import SwiftData

@main
struct MomentumApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for : [Habit.self, Mission.self])
    }
}
