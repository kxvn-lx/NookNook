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
}
