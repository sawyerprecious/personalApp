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
        aCoder.encode(year, forKey: propertyKey.year)
        aCoder.encode(month, forKey: propertyKey.month)
        aCoder.encode(day, forKey: propertyKey.day)
        aCoder.encode(hour, forKey: propertyKey.hour)
        aCoder.encode(min, forKey: propertyKey.min)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: propertyKey.title) as? String else {
            os_log("Unable to decode the title for a Schedule object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let desc = aDecoder.decodeObject(forKey: propertyKey.desc) as? String
        
        guard let year = aDecoder.decodeObject(forKey: propertyKey.year) as? String else {
            os_log("Unable to decode the year for a Schedule object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let month = aDecoder.decodeObject(forKey: propertyKey.month) as? String else {
            os_log("Unable to decode the month for a Schedule object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let day = aDecoder.decodeObject(forKey: propertyKey.day) as? String else {
            os_log("Unable to decode the day for a Schedule object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let hour = aDecoder.decodeObject(forKey: propertyKey.hour) as? String else {
            os_log("Unable to decode the hour for a Schedule object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let min = aDecoder.decodeObject(forKey: propertyKey.min) as? String else {
            os_log("Unable to decode the minute for a Schedule object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(title: title, desc: desc!, year: year, month: month, day: day, hour: hour, min: min)
        
    }
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("schedule")
    
    var title:String
    var desc:String
    var year:String
    var month:String
    var day:String
    var hour:String
    var min:String
    
    init?(title:String, desc:String, year:String, month:String, day:String, hour:String, min:String) {
        
        if title.isEmpty || year.isEmpty || month.isEmpty || day.isEmpty {
            return nil
        }
        
        self.title = title
        self.desc = desc
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.min = min
    }
    
    
    struct propertyKey {
        static let title = "title"
        static let desc = "desc"
        static let year = "year"
        static let month = "month"
        static let day = "day"
        static let hour = "hour"
        static let min = "min"
    }
    
    
}
