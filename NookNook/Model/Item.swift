//
//  Item.swift
//  NookNook
//
//  Created by Kevin Laminto on 11/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct Item: Codable, Equatable, Identifiable {
    var id: String { name }
    
    let name: String
    let image: String?
    let obtainedFrom: String?
    let isDIY: Bool?
    let isCustomisable: Bool?
    
    let variants: [String]?
    
    let category: String
    
    let buy: Int?
    let sell: Int?
    
    let set: String?
    
    let sourceNote: String?
}

let static_item = Item(name: "Acoustic guitar", image: "3FX566U", obtainedFrom: "Crafting", isDIY: true, isCustomisable: true, variants: ["3FX566U", "dob8IS9", "fJWXEXw", "CrJ1ozg", "LJROUEd", ""], category: "Housewares", buy: 200, sell: 300, set: "Instrument", sourceNote: nil)

let static_item2 = Item(name: "XXX", image: "XXX", obtainedFrom: "XXX", isDIY: true, isCustomisable: true, variants: ["XXX", "doXXXb8IS9"], category: "XXX", buy: 200, sell: 300, set: "", sourceNote: nil)
