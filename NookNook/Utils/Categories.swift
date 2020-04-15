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
    case wallMounted = "wall-mounted"
    case wallpaper, floors, rugs, photos, posters, fencing, tools
    case tops, bottoms, dresses, headwear, accessories, socks, shoes, bags
    case umbrellas, songs, recipes, fossils, construction, nookmiles, other
    case worldBugs = "bugs"
    case worldFishes = "fishes"
    case bugs = "bugsV2"
    case fishes = "fishesV2"
    
    // Static functions to returns the filtered categories
    static func items() -> [Categories] {
        return [.housewares, .miscellaneous, .wallMounted,
                .wallpaper, .floors, .rugs, .photos, .fencing, .tools, .songs,
                .other, .fossils]
    }
    
    static func wardrobes() -> [Categories] {
        return [.tops, .bottoms, .dresses, .headwear,
                .accessories, .socks, .shoes, .bags, .umbrellas]
    }
    
    static func critters() -> [Categories] {
        return [.worldBugs, .worldFishes]
    }
}
