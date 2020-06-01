//
//  Villager.swift
//  NookNook
//
//  Created by Kevin Laminto on 16/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct Villager: Codable, Equatable, Identifiable {
    var id: String { name }
    
    let name: String
    let icon: String
    let image: String
    
    let personality: String
    let bdayString: String
    
    let species: String
    let gender: String
    
    let catchphrase: String
    
    let category: String
    
}

extension Villager {
    static func == (lhs: Villager, rhs: Villager) -> Bool {
        return lhs.id == rhs.id
    }
}
