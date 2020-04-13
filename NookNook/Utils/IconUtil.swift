//
//  IconUtil.swift
//  NookNook
//
//  Created by Kevin Laminto on 13/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct IconUtil {
    
    enum IconName: String {
        case star
        case starFill = "star.fill"
        case paintbrush = "paintbrush.fill"
        case filter = "line.horizontal.3.decrease.circle"
        case xmark
    }
    
    static func systemIcon(of icon: IconName, weight: UIImage.SymbolWeight) -> UIImage {
        let config = UIImage.SymbolConfiguration(weight: weight)
        let icon = UIImage(systemName: icon.rawValue, withConfiguration: config)!
        
        return icon
    }
}
