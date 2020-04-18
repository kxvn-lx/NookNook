//
//  User.swift
//  NookNook
//
//  Created by Kevin Laminto on 18/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct User: Codable, Equatable, Identifiable {
    
    var id: String { name }
    
    var name: String
    var islandName: String
    var nativeFruit: String
}
