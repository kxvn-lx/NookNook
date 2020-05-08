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
    
    var hemisphere: DateHelper.Hemisphere
}

let static_user = User(name: "Kevin", islandName: "Tonkotsu", nativeFruit: Fruits.cherries.rawValue, hemisphere: DateHelper.Hemisphere.Southern)
