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
    
    // If new group is being created, this will know first.
    enum Group {
        case items, critters, wardrobes
    }
    
    /**
     Load all datas from the datasource - And return them for view.
        - parameters:
          - group: The current VC that invoke the method.
          - category: The category that needs to be loaded to the VC.
        - returns:
                - An array of Any, which will be typecasted individually byt its respective caller.
     */
    static func loadJSON(to group: Group, category: Categories) -> [Any] {
        var datas: [Any] = []
        
        if let path = Bundle.main.path(forResource: category.rawValue, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)["results"].array!
                
                switch group {
                case .items:
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
                        datas.append(newItem)
                    }
                    
                case .critters:
                    print("Attempt to create critter objects.")
//                    for critter in jsonObj {
//
//                    }
                    
                case .wardrobes:
                    print("Attempt to create critter objects.")
//                    for wardrobe in jsonObj {
//
//                    }
                    
                }
                
                
                
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        return datas
    }
}
