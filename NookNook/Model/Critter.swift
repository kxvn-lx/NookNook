//
//  Critter.swift
//  NookNook
//
//  Created by Kevin Laminto on 15/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Critter: Codable, Equatable, Identifiable {
    
    var id: String { name }
    
    let name: String
    let image: String
    let weather: String
    let obtainedFrom: String
    
    let time: String
    
    let activeMonthsN: String
    let activeMonthsS: String
    
    let rarity: String
    
    let category: String
    
    let sell: Int?
    
    let shadow: String?
}

extension Critter {
    static func == (lhs: Critter, rhs: Critter) -> Bool {
        return lhs.id == rhs.id
    }
}
