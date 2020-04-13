//
//  PriceEngine.swift
//  NookNook
//
//  Created by Kevin Laminto on 13/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct PriceEngine {
    
    enum Price: String {
        case buy = "Buy for: "
        case sell = "Sell for: "
    }
    
    static func renderPrice(amount: Int?, with price: Price) -> NSMutableAttributedString {
        
        let body: String = amount != nil ? String(amount!) : "-"
        
        let titleAttr = [NSAttributedString.Key.font :  UIFont.systemFont(ofSize: 12, weight: .semibold)]
        let finalString = NSMutableAttributedString(string: price.rawValue, attributes:titleAttr)
        
        let bodyString = NSMutableAttributedString(string: body)
        
        finalString.append(bodyString)
        
        return finalString
    }
}
