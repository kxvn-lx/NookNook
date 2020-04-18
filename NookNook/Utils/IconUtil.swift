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
        case sort = "arrow.up.arrow.down.circle"
    }
    
    /**
     This method will render an icon based on the system icon.
     - Parameters:
        - icon: The icon's system name.
        - weight: The weight of the icon.
     - Returns:
        - A UIImage of the icon.
     */
    static func systemIcon(of icon: IconName, weight: UIImage.SymbolWeight) -> UIImage {
        let config = UIImage.SymbolConfiguration(weight: weight)
        let icon = UIImage(systemName: icon.rawValue, withConfiguration: config)!
        
        return icon
    }
    
    /**
     This method will render a custom icon based.
     - Parameters:
        - icon: The icon's system name.
     - Returns:
        - A UIImage of the icon.
     */
    static func customIcon(of icon: IconName) -> UIImage {
        let icon = UIImage(named: icon.rawValue)!
        
        
        return icon
    }
}
