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
            fatalError("Invalid filename/path on items")
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
    // THIS FUNCTION WILL ONLY LOAD DATA FROM ALEXIS
    static func loadCritterJSON(from category: Categories) -> [Critter] {
        var critters: [Critter] = []
        
        var weathers: [String: String] = [:]
        var rarities: [String: String] = [:]
        
        var cat: String!
        
        // Load datas from secondary JSON files (bugsSecondary.JSON)
        switch category {
        case .bugsMain:
            (weathers, rarities) = loadSecondCritterJSON(with: .bugsSecondary)
            cat = Categories.bugs.rawValue
        case .fishesMain:
            (weathers, rarities) = loadSecondCritterJSON(with: .fishesSecondary)
            cat = Categories.fishes.rawValue
        default:
            fatalError("Passing an invalid categories to loadCritterJSON method. Check the category to make sure you have passed the right categories!")
        }
        
        // Load Data from the main JSON file (bugsMain.JSON)
        if let path = Bundle.main.path(forResource: category.rawValue, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data).dictionary!
                
                let obj = jsonObj.keys.sorted()
                
                for k in obj {
                    let key = jsonObj[k]!
                    let weather = weathers[key["name"]["name-en"].stringValue] != nil ? weathers[key["name"]["name-en"].stringValue]! : "Unknown"
                    let rarity = rarities[key["name"]["name-en"].stringValue] != nil ? rarities[key["name"]["name-en"].stringValue]! : "Unknown"
                    
                    
                    let newCritter = Critter(name: key["name"]["name-en"].stringValue,
                                             image: key["id"].stringValue,
                                             weather: weather,
                                             obtainedFrom: key["availability"]["location"].stringValue,
                                             time: key["availability"]["time"].stringValue,
                                             activeMonthsN: key["availability"]["month-northern"].stringValue,
                                             activeMonthsS: key["availability"]["month-southern"].stringValue,
                                             rarity: rarity,
                                             category: cat,
                                             sell: key["price"].intValue
                    )
                    critters.append(newCritter)
                }
                

                
                
                
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path on critters")
        }
        
        
        
        return critters
    }
    
    // This function will only load JSON files from NOOKPLAZA
    static private func loadSecondCritterJSON(with category: Categories) -> ( [String: String], [String: String] ) {
        // save active months array from the other JSON file.
        var weathers: [String: String] = [:]
        var rarities: [String: String] = [:]
        
        if let path = Bundle.main.path(forResource: category.rawValue, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)["results"].array!
                
                // iterate the data and ONLY get the active months
                for data in jsonObj {
                    rarities[data["name"].stringValue] = data["rarity"].stringValue
                    weathers[data["name"].stringValue] = data["weather"].stringValue
                }
                
            } catch let error {
                fatalError("parse error: \(error.localizedDescription)")
            }
        } else {
            fatalError("Invalid filename/path on loading secondary critters data.")
        }
        
        return (weathers, rarities)
    }
    
    
    /**
     Load Wardrobes datas from the datasrouce - and return them for view.
     - Parameters:
        - category: The category  that needs to be loaded to the VC.
     - Returns:
        - An array of wardrobes, ready to be rendered.
     */
    static func loadWardrobesJSON(from category: Categories) -> [Wardrobe] {
        var wardrobes: [Wardrobe] = []
        
        if let path = Bundle.main.path(forResource: category.rawValue, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)["results"].array!
                
                
                for wardrobe in jsonObj {
                    let newWardrobe = Wardrobe(name: wardrobe["name"].stringValue,
                                               image: wardrobe["image"].stringValue,
                                               obtainedFrom: wardrobe["obtainedFrom"].stringValue,
                                               isDIY: wardrobe["dIY"].boolValue,
                                               variants: wardrobe["variants"].arrayObject as? [String],
                                               category: wardrobe["category"].stringValue,
                                               buy: wardrobe["buy"].intValue,
                                               sell: wardrobe["sell"].intValue
                    )
                    wardrobes.append(newWardrobe)
                }
            } catch let error {
                fatalError("parse error: \(error.localizedDescription)")
            }
        } else {
            fatalError("Invalid filename/path on wardrobes")
        }
        
        return wardrobes
    }
    
    
    /**
     Load Villagers datas from the datasrouce - and return them for view.
     - Parameters:
        - category: The category  that needs to be loaded to the VC.
     - Returns:
        - An array of Villagers, ready to be rendered.
     */
    static func loadVillagersJSON(from category: Categories) -> [Villager] {
        var villagers: [Villager] = []
        
        if let path = Bundle.main.path(forResource: category.rawValue, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data).dictionary!
                
                for key in jsonObj {
                    let v = key.value
                    let newVillager = Villager(name: v["name"]["name-en"].stringValue,
                                               image: v["id"].stringValue,
                                               personality: v["personality"].stringValue,
                                               bdayString: v["birthday-string"].stringValue,
                                               species: v["species"].stringValue,
                                               gender: v["gender"].stringValue,
                                               catchphrase: v["catch-phrase"].stringValue
                    )
                    villagers.append(newVillager)
                }
                
            } catch let error {
                fatalError("parse error: \(error.localizedDescription)")
            }
        } else {
            fatalError("Invalid filename/path on villagers")
        }
        
        return villagers
    }
    
    
    /**
     Load any JSON for experimenting.
     - Parameters:
        - fileName: The file's name
     */
    static func loadExperimentalJSON(with fileName: String) {
        
//        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                let jsonObj = try JSON(data: data).dictionary!
//
//
//
//            } catch let error {
//                fatalError("parse error: \(error.localizedDescription)")
//            }
//        } else {
//            fatalError("Invalid filename/path on experimental JSON. You are accessing this file that does not exist! \(fileName).json")
//        }
        
    }
}
