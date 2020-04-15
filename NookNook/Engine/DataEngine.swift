//
//  DataEngine.swift
//  NookNook
//
//  Created by Kevin Laminto on 13/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct DataEngine {
    
    enum Group {
        case items, critters, wardrobes
    }
    
    /**
     Load Item datas from the datasrouce - and return them for view.
     - Parameters:
        - category: The category that needs to be loaded to the VC.
     - Returns:
        - An array of Items, ready to be rendered.
     */
    static func loadItemJSON(from category: Categories) -> [Item] {
        var items: [Item] = []
        
        if let path = Bundle.main.path(forResource: category.rawValue, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)["results"].array!
                
                
                for item in jsonObj {
                    let newItem = Item(
                        name: item["name"].stringValue,
                        image: item["image"].stringValue,
                        obtainedFrom: item["obtainedFrom"].stringValue,
                        isDIY: item["dIY"].boolValue,
                        isCustomisable: item["customize"].boolValue,
                        variants: item["variants"].arrayObject as? [String],
                        category: item["category"].stringValue,
                        buy: item["buy"].intValue,
                        sell: item["sell"].intValue,
                        set: item["set"].stringValue
                    )
                    items.append(newItem)
                }
            } catch let error {
                fatalError("parse error: \(error.localizedDescription)")
            }
        } else {
            fatalError("Invalid filename/path.")
        }
        
        return items
    }
    
    
    /**
     Load Critters datas from the datasrouce - and return them for view.
     - Parameters:
        - category: The category  that needs to be loaded to the VC.
     - Returns:
        - An array of critters, ready to be rendered.
     */
    static func loadCritterJSON(from category: Categories) -> [Critter] {
        var critters: [Critter] = []
        
        if let path = Bundle.main.path(forResource: category.rawValue, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)["results"].array!
                
                // save active months array from the other JSON file.
                var activeMonthsN: [[Int]] = []
                var activeMonthsS: [[Int]] = []
                var rarities: [String] = []
                
                if let path = Bundle.main.path(forResource: Categories.bugs.rawValue, ofType: "json") {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                        let jsonObj = try JSON(data: data)["results"].array!
                        
                        // iterate the data and ONLY get the active months
                        for data in jsonObj {
                            activeMonthsN.append(data["activeMonthsNorth"].arrayObject as! [Int])
                            activeMonthsS.append(data["activeMonthsSouth"].arrayObject as! [Int])
                            rarities.append(data["rarity"].stringValue)
                        }
                    } catch let error {
                        fatalError("parse error: \(error.localizedDescription)")
                    }
                } else {
                    fatalError("Invalid filename/path.")
                }
                
                var critterCount = 0
                for critter in jsonObj {
                    let newCritter = Critter(
                        name: critter["name"].stringValue,
                        image: critter["image"].stringValue,
                        weather: critter["weather"].stringValue,
                        obtainedFrom: critter["obtainedFrom"].stringValue,
                        startTime: critter["startTime"],
                        endTime: critter["endTime"],
                        activeMonthsN: activeMonthsN[critterCount],
                        activeMonthsS: activeMonthsS[critterCount],
                        rarity: rarities[critterCount],
                        category: critter["category"].stringValue,
                        sell: critter["sell"].intValue
                    )
                    critterCount += 1
                    critters.append(newCritter)
                }
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
        
        
        return critters
    }
}
