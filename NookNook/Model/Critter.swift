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
    let image: String?
    let weather: String
    let obtainedFrom: String
    
    let startTime: JSON
    let endTime: JSON
    let activeMonths: [Int]
    
    
    let category: String
    
    let sell: Int?
}
