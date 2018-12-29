//
//  ChecklistItem.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-12-20.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.itemName, forKey: propertyKey.itemName)
        aCoder.encode(self.onOff, forKey: propertyKey.onOff)
        aCoder.encode(self.status, forKey: propertyKey.status)
        aCoder.encode(self.timeOfDay, forKey: propertyKey.timeOfDay)
        aCoder.encode(self.lastCompleted, forKey: propertyKey.lastCompleted)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let itemName = aDecoder.decodeObject(forKey: propertyKey.itemName) as? String else {
            return nil
        }
        
        let onOff = aDecoder.decodeBool(forKey: propertyKey.onOff)
        
        let status = aDecoder.decodeBool(forKey: propertyKey.status)
        
        let timeOfDay = aDecoder.decodeCInt(forKey: propertyKey.timeOfDay)
        
        
        guard let lastCompleted = aDecoder.decodeObject(forKey: propertyKey.lastCompleted) as? Date else {
            return nil
        }
        
        
        
        self.init(itemName: itemName, onOff: onOff, status: status, tod: Int(timeOfDay), lc: lastCompleted)
        }
        
    
    
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("checklist")
    
    var itemName: String
    var onOff: Bool
    var status: Bool
    var timeOfDay: Int
    var lastCompleted: Date
    
    
    init?(itemName: String, onOff: Bool, status: Bool, tod: Int, lc: Date) {
        
        if itemName.isEmpty {
            return nil
        }
        
        self.itemName = itemName
        self.onOff = onOff
        self.status = status
        self.timeOfDay = tod
        self.lastCompleted = lc
    }
    
    
    struct propertyKey {
        static let itemName = "itemName"
        static let onOff = "onOff"
        static let status = "status"
        static let timeOfDay = "timeOfDay"
        static let lastCompleted = "lastCompleted"
    }
    
    enum timeDay: Int {
        case early = 0
        case mid = 1
        case late = 2
    }
}
