//
//  Note.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-05-14.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import Foundation
import os.log


class Note: NSObject, NSCoding {
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: propertyKey.name)
        aCoder.encode(contents, forKey: propertyKey.contents)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: propertyKey.name) as? String else{
            os_log("Couldn't decode the name for a Note object", log: OSLog.default, type: .debug)
            return nil
        }
        
        let contents = aDecoder.decodeObject(forKey: propertyKey.contents) as? String
        
        self.init(name: name, contents: contents!)
    }
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("notes")
    
    
    var name: String
    var contents: String
    
    init?(name: String, contents: String){
        
        if name.isEmpty{
            return nil
        }
        self.name = name
        self.contents = contents
    }
    
    
    struct propertyKey {
        static let name = "name"
        static let contents = "contents"
    }
}
