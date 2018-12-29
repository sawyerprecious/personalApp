//
//  LocalPushManager.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-08-19.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import Foundation
import UserNotifications

class LocalPushManager: NSObject {
    static var shared = LocalPushManager()
    let centre = UNUserNotificationCenter.current()
    
    func requestAuth() {
        centre.requestAuthorization(options: [.alert, .badge], completionHandler: {(granted, error) in
            if error != nil {
                print("Something went wrong requesting authorization.")
            }
        })
    }
    
    
    func sendLocalPush(on: DateComponents, withMessage: String, db: Date) {
        
        let hContent = UNMutableNotificationContent()
        hContent.title = "Upcoming Event"
        hContent.body = withMessage + ", in 3 hours"
        hContent.badge = 1
        
        let dayBeforeDate = db
        let dayBefore = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dayBeforeDate)
        
        var hoursBefore = on
        hoursBefore.hour = (hoursBefore.hour ?? 0) > 3 ? (hoursBefore.hour ?? 0) - 3 : (hoursBefore.hour ?? 0)
        
        
        if (on.hour ?? 0) > 3 {
            let hTrigger = UNCalendarNotificationTrigger(dateMatching: hoursBefore, repeats: false)
            let hIdentifier = "THEventID" + String(hContent.title)
            let hRequest = UNNotificationRequest(identifier: hIdentifier, content: hContent, trigger: hTrigger)
            
            centre.add(hRequest, withCompletionHandler: {(error) in
                if error != nil {
                    print("Something went wrong adding request to notif centre.")
                }
            })
        }
        
        
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Event"
        content.body = withMessage + ", tomorrow at " + String(on.hour ?? 0) + ":" + String(on.minute ?? 0 < 10 ? "0" : "") + String(on.minute ?? 0)
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dayBefore, repeats: false)
        let identifier = "DBEventID" + String(content.title)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        centre.add(request, withCompletionHandler: {(error) in
            if error != nil {
                print("Something went wrong adding request to notif centre.")
            }
        })
    }
    
    func sendRepeatingLocalPush(timeOfDay: Int, taskList: [ChecklistItem]) {
        let content = UNMutableNotificationContent()
        
        var dateComponents = DateComponents()
        
        switch timeOfDay {
        case 1:
            content.title = "You have midday tasks to do"
            dateComponents.hour = 12
            dateComponents.minute = 30
        case 2:
            content.title = "You have evening tasks to do"
            dateComponents.hour = 20
            dateComponents.minute = 30
        default:
            content.title = "You have morning tasks to do"
            dateComponents.hour = 8
            dateComponents.minute = 30
        }
        
        var msg = "Tasks are: "
        
        var temp = taskList
        temp.removeLast()
        
        for task in temp {
            msg += task.itemName + ", "
        }
        
        if taskList.count >= 2 {
            msg += "and " + (taskList.last?.itemName)!
        } else {
            msg += taskList.last?.itemName ?? ""
        }
        
        content.body = msg
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true)
        
        
        let identifier = "checklist" + String(content.title)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        centre.add(request, withCompletionHandler: {(error) in
            if error != nil {
                print("Something went wrong adding request to notif centre.")
            }
        })
    }
    
    func removeRequest(withID: String) {
        centre.removePendingNotificationRequests(withIdentifiers: [withID])
    }
    
}
