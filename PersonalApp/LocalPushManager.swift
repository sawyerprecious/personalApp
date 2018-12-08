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
    
}
