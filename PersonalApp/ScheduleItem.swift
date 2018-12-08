//
//  Schedule.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-05-12.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit
import os.log


class ScheduleItem: NSObject, NSCoding{
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: propertyKey.title)
        aCoder.encode(desc, forKey: propertyKey.desc)
        aCoder.encode(day, forKey: propertyKey.day)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: propertyKey.title) as? String else {
            os_log("Unable to decode the title for a Schedule object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let desc = aDecoder.decodeObject(forKey: propertyKey.desc) as? String
        
    
        guard let day = aDecoder.decodeObject(forKey: propertyKey.day) as? Date else {
            os_log("Unable to decode the day for a Schedule object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        self.init(title: title, desc: desc!, day: day)
        
    }
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("schedule")
    
    var title:String
    var desc:String
    var day:Date
    
    
    init?(title:String, desc:String, day:Date) {
    
        if title.isEmpty {
            return nil
        }
        
        self.title = title
        self.desc = desc
        self.day = day
    }
    
    
    struct propertyKey {
        static let title = "title"
        static let desc = "desc"
        static let day = "day"
    }
    
    
}
