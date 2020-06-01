//
//  Categories.swift
//  NookNook
//
//  Created by Kevin Laminto on 13/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

enum Categories: String {
    case housewares, miscellaneous
    case art
    case wallMounted = "wall-mounted"
    case wallpapers, floors, rugs, photos, posters, fencing, tools
    case tops, bottoms, dresses, headwear, accessories, socks, shoes, bags
    case umbrellas, music, recipes, fossils, construction, nookmiles, other
    
    case bugs, fishes
    
    case bugsMain
    case bugsSecondary
    
    case fishesMain
    case fishesSecondary

    case villagers
    
    // Static functions to returns the filtered categories
    static func items() -> [Categories] {
        return [.housewares, .miscellaneous, .wallMounted, .art,
                .wallpapers, .floors, .rugs, .photos, .fencing, .tools, .music, .fossils]
    }
    
    static func wardrobes() -> [Categories] {
        return [.tops, .bottoms, .dresses, .headwear,
                .accessories, .socks, .shoes, .bags, .umbrellas]
    }
    
    static func critters() -> [Categories] {
        return [.bugsMain, .fishesMain]
    }
    
}
