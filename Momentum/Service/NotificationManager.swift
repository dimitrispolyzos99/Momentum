//
//  NotificationManager.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 15/4/26.
//

import UserNotifications

struct NotificationManager {
    
    static func scheduleDailyReminder() {
        let center = UNUserNotificationCenter.current()
        
        // Remove existing to avoid duplicates
        center.removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
        
        let content = UNMutableNotificationContent()
        content.title = "Your missions await ⚡️"
        content.body = "Complete today's missions and keep your streak alive!"
        content.sound = .default
        
        // Fire every day at 9:00 AM
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        center.add(request)
    }
    
    static func scheduleStreakReminder() {
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(withIdentifiers: ["streakReminder"])
        
        let content = UNMutableNotificationContent()
        content.title = "Don't break your streak! 🔥"
        content.body = "You still have missions to complete today."
        content.sound = .default
        
        // Fire at 8:00 PM as a last reminder
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "streakReminder", content: content, trigger: trigger)
        
        center.add(request)
    }
}
