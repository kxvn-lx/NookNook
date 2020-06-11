//
//  Wardrobe.swift
//  NookNook
//
//  Created by Kevin Laminto on 15/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct Wardrobe: Codable, Equatable, Identifiable {
    var id: String { name }
    
    let name: String
    let image: String?
    let obtainedFrom: String?
    let isDIY: Bool?
    
    let variants: [String]?
    
    let category: String
    
    let buy: Int?
    let sell: Int?
    
    let sourceNote: String?
    
    static let empty_wardrobe = Wardrobe(name: "EMPTY_WARDROBE", image: nil, obtainedFrom: nil, isDIY: nil, variants: nil, category: "EMPTY_WARDROBE", buy: nil, sell: nil, sourceNote: nil)
}

extension Wardrobe {
    static func == (lhs: Wardrobe, rhs: Wardrobe) -> Bool {
        return lhs.id == rhs.id
    }
}
