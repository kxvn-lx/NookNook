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
    let image: String
    
    let personality: String
    let bdayString: String
    
    let species: String
    let gender: String
    
    let catchphrase: String
    
    let category: String
    
}

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] > b[keyPath: keyPath]
        }
    }
}
