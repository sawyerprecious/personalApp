//
//  Recipe.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-05-15.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import Foundation
import os.log
import UIKit


class Recipe: NSObject, NSCoding {
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(mealName, forKey: propertyKey.mealName)
        aCoder.encode(foodImage, forKey: propertyKey.foodImage)
        aCoder.encode(ingredients, forKey: propertyKey.ingredients)
        aCoder.encode(instructions, forKey: propertyKey.instructions)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let mealName = aDecoder.decodeObject(forKey: propertyKey.mealName) as? String else{
            os_log("Couldn't decode the name for a Recipe object", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let foodImage = aDecoder.decodeObject(forKey: propertyKey.foodImage) as? UIImage else{
            os_log("Couldn't decode the image for a Recipe object", log: OSLog.default, type: .debug)
            return nil
        }
        
        let ingredients = aDecoder.decodeObject(forKey: propertyKey.ingredients) as? String
        
        let instructions = aDecoder.decodeObject(forKey: propertyKey.instructions) as? String
        
        self.init(mealName: mealName, foodImage: foodImage, ingredients: ingredients!, instructions: instructions!)
    }
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("recipes")
    
    var mealName: String
    var foodImage: UIImage
    var ingredients: String?
    var instructions: String?
    
    init?(mealName:String, foodImage:UIImage, ingredients:String, instructions:String){
        
        if mealName.isEmpty{
            return nil
        }
        self.mealName = mealName
        self.foodImage = foodImage
        self.ingredients = ingredients
        self.instructions = instructions
    }
    
    
    struct propertyKey {
        static let mealName = "mealName"
        static let foodImage = "foodImage"
        static let ingredients = "ingredients"
        static let instructions = "instructions"
    }
}
