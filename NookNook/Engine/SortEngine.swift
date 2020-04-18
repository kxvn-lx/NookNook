//
//  SortEngine.swift
//  NookNook
//
//  Created by Kevin Laminto on 18/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct SortEngine {
    
    enum Sort: String {
        case name, personality, species
    }
    
    static func sortVillagers(villagers: [Villager], with sortType: Sort) -> [Villager] {
        
        switch sortType {
        case .name:
            return villagers.sorted(by: { $0.name < $1.name })
        case .personality:
            return villagers.sorted(by: { $0.personality < $1.personality })
        case .species:
            return villagers.sorted(by: { $0.species < $1.species })
        }
    }
}
