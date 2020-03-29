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
    var valueInDollars: Int
    var plantSize: String?
    let dateCreated: Date
    let itemKey: String
    
    init(name: String, plantSize: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.plantSize = plantSize
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Spider", "Air", "Snake"]
            let nouns = ["Plant"]
            let size = ["Small", "Medium", "Large"]
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(100))
            idx = arc4random_uniform(UInt32(size.count))
            let randomPlantSize = size[Int(idx)]
            self.init(name: randomName, plantSize: randomPlantSize, valueInDollars: randomValue)
        } else {
            self.init(name: "", plantSize: nil, valueInDollars: 0) }
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        plantSize = aDecoder.decodeObject(forKey: "plantSize") as! String?
        
        valueInDollars = aDecoder.decodeInteger(forKey: "valueInDollars")
        
        super.init()
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(dateCreated, forKey: "dateCreated")
        aCoder.encode(itemKey, forKey: "itemKey")
        aCoder.encode(plantSize, forKey: "plantSize")
        
        aCoder.encode(valueInDollars, forKey: "valueInDollars")
    }
    
}
