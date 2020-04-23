//
//  Item.swift
//  Homepwner
//
//  Created by Mary Livingston on 2/29/20.
//  Copyright © 2020 Mary Livingston. All rights reserved.
//

import UIKit
class Item: NSObject, NSCoding {
    var name: String
    var light: String
    var water: String
    var plantSize: String?
    var valueInDollars: Int
    var notes: String?
    let dateCreated: Date
    let itemKey: String
    
    init(name: String, light: String, water: String, plantSize: String?, valueInDollars: Int, notes: String?) {
        self.name = name
        self.light = light
        self.water = water
        self.plantSize = plantSize
        self.valueInDollars = valueInDollars
        self.notes = notes
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
        
        super.init()
    }
    
    convenience init(random: Bool) {
        if random {
            let plants = ["Spider Plant", "Air Plant", "Snake Plant", "Croton", "Cactus", "Pothos", "Fern", "String of Pearls", "String of Turtles"]
            let lightPref = ["Full Sun", "Part Sun", "In-direct light", "Shade"]
            let waterPref = ["Weekly, Bi-Weekly", "Monthly", "When completly dry"]
            let size = ["Small", "Medium", "Large"]
            
            var idx = arc4random_uniform(UInt32(plants.count))
            let randomName = plants[Int(idx)]
            
            idx = arc4random_uniform(UInt32(lightPref.count))
            let randomLight = lightPref[Int(idx)]
            
            idx = arc4random_uniform(UInt32(waterPref.count))
            let randomWater = waterPref[Int(idx)]
            
            idx = arc4random_uniform(UInt32(size.count))
            let randomPlantSize = size[Int(idx)]
            
            let randomValue = Int(arc4random_uniform(100))
            
            self.init(name: randomName, light: randomLight, water: randomWater, plantSize: randomPlantSize, valueInDollars: randomValue, notes: nil)
        } else {
            self.init(name: "", light: "", water: "", plantSize: nil, valueInDollars: 0, notes: nil) }
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        light = aDecoder.decodeObject(forKey: "light") as! String
        water = aDecoder.decodeObject(forKey: "water") as! String
        plantSize = aDecoder.decodeObject(forKey: "plantSize") as! String?
        valueInDollars = aDecoder.decodeInteger(forKey: "valueInDollars")
        notes = aDecoder.decodeObject(forKey: "note") as! String?
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        
        super.init()
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(light, forKey: "light")
        aCoder.encode(water, forKey: "water")
        aCoder.encode(plantSize, forKey: "plantSize")
        aCoder.encode(valueInDollars, forKey: "valueInDollars")
        aCoder.encode(notes, forKey: "notes")
        aCoder.encode(dateCreated, forKey: "dateCreated")
        aCoder.encode(itemKey, forKey: "itemKey")
        
    }
    
}
