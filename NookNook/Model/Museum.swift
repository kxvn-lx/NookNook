//
//  Museum.swift
//  NookNook
//
//  Created by Kevin Laminto on 1/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct Museum: Codable, Equatable, Identifiable {
    
    var id: String { name }
    
    let name: String
    let image: String
    let weather: String?
    let obtainedFrom: String?
    
    let time: String?
    
    let activeMonthsN: String?
    let activeMonthsS: String?
    
    let rarity: String?
    
    let category: String
    
    let sell: Int?
    
    let shadow: String?
}

extension Museum {
    static func == (lhs: Museum, rhs: Museum) -> Bool {
        return lhs.id == rhs.id
    }
}
