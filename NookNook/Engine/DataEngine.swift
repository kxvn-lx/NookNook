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
        case items, critters, wardrobes, villagers
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
                    var imagesArr: [String] = []
                    
                    for variant in item["variants"] {
                        imagesArr.append(variant.1["filename"].stringValue)
                    }
                    
                    let name = item["name"].stringValue
                    let image = item["filename"].stringValue
                    let obtainedFrom = item["obtainedFrom"].stringValue
                    let isDIY = item["dIY"].boolValue
                    let isCustomisable = item["customize"].boolValue
                    let variants = imagesArr.count > 1 ? Array(imagesArr.dropFirst()) : nil
                    let category = item["category"].stringValue
                    let buy = item["buy"].intValue
                    let sell = item["sell"].intValue
                    let set = item["set"].stringValue
                    
                    let newItem = Item(name: name, image: image, obtainedFrom: obtainedFrom, isDIY: isDIY, isCustomisable: isCustomisable, variants: variants, category: category, buy: buy, sell: sell, set: set)
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
        
        var cat: String!
        
        // Load datas from secondary JSON files (bugsSecondary.JSON)
        switch category {
        case .bugsMain:
            (weathers) = loadSecondCritterJSON(with: .bugsSecondary)
            cat = Categories.bugs.rawValue
        case .fishesMain:
            (weathers) = loadSecondCritterJSON(with: .fishesSecondary)
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
                    
                    let newCritter = Critter(name: key["name"]["name-en"].stringValue,
                                             image: key["id"].stringValue,
                                             weather: weather,
                                             obtainedFrom: key["availability"]["location"].stringValue,
                                             time: key["availability"]["time"].stringValue,
                                             activeMonthsN: key["availability"]["month-northern"].stringValue,
                                             activeMonthsS: key["availability"]["month-southern"].stringValue,
                                             rarity: key["availability"]["rarity"].stringValue,
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
    static private func loadSecondCritterJSON(with category: Categories) -> ( [String: String] ) {
        // save active months array from the other JSON file.
        var weathers: [String: String] = [:]
        
        if let path = Bundle.main.path(forResource: category.rawValue, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)["results"].array!
                
                // iterate the data and ONLY get the active months
                for data in jsonObj {
                    weathers[data["name"].stringValue] = data["weather"].stringValue
                }
                
            } catch let error {
                fatalError("parse error: \(error.localizedDescription)")
            }
        } else {
            fatalError("Invalid filename/path on loading secondary critters data.")
        }
        
        return (weathers)
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
                    var imagesArr: [String] = []
                    
                    for variant in wardrobe["variants"] {
                        imagesArr.append(variant.1["filename"].stringValue)
                    }
                    
                    let name = wardrobe["name"].stringValue
                    let image = wardrobe["filename"].stringValue
                    let obtainedFrom = wardrobe["obtainedFrom"].stringValue
                    let isDIY = wardrobe["dIY"].boolValue
                    let variants = imagesArr.count > 1 ? Array(imagesArr.dropFirst()) : nil
                    let category = wardrobe["category"].stringValue
                    let buy = wardrobe["buy"].intValue
                    let sell = wardrobe["sell"].intValue

                    let newWardrobe = Wardrobe(name: name, image: image, obtainedFrom: obtainedFrom, isDIY: isDIY, variants: variants, category: category, buy: buy, sell: sell)
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
                
                let obj = jsonObj.keys.sorted()
                
                for k in obj {
                    let key = jsonObj[k]!
                    let newVillager = Villager(name: key["name"]["name-en"].stringValue,
                                               image: key["id"].stringValue,
                                               personality: key["personality"].stringValue,
                                               bdayString: key["birthday-string"].stringValue,
                                               species: key["species"].stringValue,
                                               gender: key["gender"].stringValue,
                                               catchphrase: key["catch-phrase"].stringValue,
                                               category: Categories.villagers.rawValue
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
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let _ = try JSON(data: data)["results"].array!

                
                


            } catch let error {
                fatalError("parse error: \(error.localizedDescription)")
            }
        } else {
            fatalError("Invalid filename/path on experimental JSON. You are accessing this file that does not exist! \(fileName).json")
        }
        
    }
}
