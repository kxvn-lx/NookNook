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
    case bugsNorth = "bugs-north"
    case bugsSouth = "bugs-south"
    case fishesNorth = "fish-north"
    case fishesSouth = "fish-south"
    case bugs, fishes
    
    // Static functions to returns the filtered categories
    static func items() -> [Categories] {
        return [.housewares, .miscellaneous, .wallMounted,
                .wallpaper, .floors, .rugs, .photos, .fencing, .tools, .songs,
                .recipes, .other, .fossils]
    }
    
    static func wardrobe() -> [Categories] {
        return [.tops, .bottoms, .dresses, .headwear,
                .accessories, .socks, .shoes, .bags, .umbrellas]
    }
    
    static func critters() -> [Categories] {
        return [.bugsNorth, .bugsSouth, .fishesNorth, .fishesSouth]
    }
}
