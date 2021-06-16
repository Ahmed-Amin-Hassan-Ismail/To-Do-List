//
//  TodoList.swift
//  TodoList
//
//  Created by Amin  on 5/31/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class ToDoItems: NSObject, Codable {
    
    var title: String = ""
    var ischecked: Bool = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    override init() {
        super.init()
        itemID = DataModel.nextToDOItemID()
    }
    
    deinit {
        removeNotification()
    }
    
    func isToggle() {
        ischecked = !ischecked
    }
    
    // MARK: - Local Notification
    
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            
            // User Notification
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = title
            content.sound = UNNotificationSound.default
            
            // Create calender
            let calender = Calendar(identifier: .gregorian)
            let component = calender.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: dueDate)
            
            // Ceate Trigger
            let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
            
            // Create request
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
        }
    }
    
   private func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    
}
