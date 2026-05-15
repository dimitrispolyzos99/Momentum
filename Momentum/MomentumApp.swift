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
import FirebaseAuth

@main
struct MomentumApp: App {

    @StateObject private var authState = AuthState()

    init() {
        requestNotificationPermission()
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authState.isLoggedIn {
                HomeView()
            } else {
                LoginView()
            }
        }
        .modelContainer(for: [Habit.self, Mission.self, PlayerProgress.self])
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
