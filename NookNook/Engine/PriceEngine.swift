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
    
    /**
     Render the price into a better visual
     - parameters:
        - amount: The amount of the price
        - price: The title of the price, either buy or sell.
     - Returns:
        - An attributed string with a rendered format.
     */
    static func renderPrice(amount: Int?, with price: Price) -> NSMutableAttributedString {
        
        let body: String = amount != 0 ? String(amount!) : "-"
        
        let priceAttr = [NSAttributedString.Key.font :  UIFont.systemFont(ofSize: 12, weight: .semibold)]
        let finalString = NSMutableAttributedString(string: body, attributes:priceAttr)
        
        let bodyString = NSMutableAttributedString(string: price.rawValue)
        
        
        bodyString.append(finalString)
        
        return bodyString
    }
}
