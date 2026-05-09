//
//  MomentumApp.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 31/3/26.
//

import SwiftUI
import SwiftData
import UserNotifications
import FirebaseCore

@main
struct MomentumApp: App {
    
    init() {
        requestNotificationPermission()
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
        .modelContainer(for : [Habit.self, Mission.self, PlayerProgress.self])
    }
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                NotificationManager.scheduleDailyReminder()
                NotificationManager.scheduleStreakReminder()
            }
        }
    }
}	
