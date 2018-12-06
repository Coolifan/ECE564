//
//  Notification.swift
//  MoveIt
//
//  Created by Zi Xiong on 12/5/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import Foundation
import UserNotifications

class Notification {
    static func scheduledtime(identifier: String, dateSet: Date) {
        let calendar = Calendar.current
        let comp2 = calendar.dateComponents([.hour,.minute], from: dateSet)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp2, repeats: true)
        
        let content = UNMutableNotificationContent()
        switch identifier {
        case "Breakfast":
            content.title = "MoveIt Notification"
            content.subtitle = "Breakfast Reminder"
            content.body = "Hi \(Settings.userName), It's breakfast time!"
        case "Lunch":
            content.title = "MoveIt Notification"
            content.subtitle = "Lunch Reminder"
            content.body = "Hi \(Settings.userName), It's lunch time!"
        case "Dinner":
            content.title = "MoveIt Notification"
            content.subtitle = "Dinner Reminder"
            content.body = "Hi \(Settings.userName), It's dinner time!"
        default:
            content.title = "MoveIt Notification"
            content.subtitle = "Meal Reminder"
            content.body = "Hi \(Settings.userName), It's time for meal!"
        }
        
        let request = UNNotificationRequest(
            identifier: "scheduled", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
