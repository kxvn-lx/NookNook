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
    let dIY: Bool?
    let customize: Bool?
    
    let variants: [String]?
    
    let category: String
    
    let buy: Int?
    let sell: Int?
    
    let set: String?
}

let static_item = Item(name: "Acoustic Guitar",
    image: "3FX566U",
    obtainedFrom: "Crafting",
    dIY: true,
    customize: true,
    variants: ["3FX566U", "dob8IS9", "fJWXEXw", "CrJ1ozg", "LJROUEd", ""],
    category: "Housewares",
    buy: 200,
    sell: 1300,
    set: "Instrument"
)
