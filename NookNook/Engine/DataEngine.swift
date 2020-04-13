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
    
    enum Categories: String {
        case housewares, miscellaneous
        case wallMounted = "wall-mounted"
        case wallpaper, floors, rugs, photos, posters, fencing, tools
        case tops, bottoms, dresses, headwear, accessories, socks, shoes, bags
        case umbrellas, songs, recipes, fossils, construction, nookmiles, other
        case bugsNorth = "bugs-north"
        case bugsSouth = "bugs-south"
        case fishesNorth = "fish-north"
        case fishesSouth = "fish-south"
    }
    
    /**
     Load all items from the datasource - And return them for view.
     */
    static func loadJSON(category: Categories) -> [Item] {
        var jsonObj: [JSON] = []
        var items: [Item] = []
        
        if let path = Bundle.main.path(forResource: category.rawValue, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                jsonObj = try JSON(data: data)["results"].array!
                
                for item in jsonObj {
                    let newItem = Item(name: item["name"].stringValue, image: item["image"].stringValue, obtainedFrom: item["obtainedFrom"].stringValue, isDIY: item["dIY"].boolValue, isCustomisable: item["customize"].boolValue, variants: item["variants"].arrayObject as? [String], category: item["category"].stringValue, buy: item["buy"].intValue, sell: item["sell"].intValue, set: item["set"].stringValue)
                    items.append(newItem)
                }
                
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        return items
    }
}
