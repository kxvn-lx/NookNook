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
        case none = ""
    }
    
    /**
     Render the price into a better visual
     - parameters:
        - amount: The amount of the price
        - price: The title of the price, either buy or sell.
     - Returns:
        - An attributed string with a rendered format.
     */
    static func renderPrice(amount: Int?, with price: Price, of size: CGFloat) -> NSMutableAttributedString {
        
        // Format the price for better readability.
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:amount!))!
        
        var body: String = ""
        switch price {
        case .buy, .sell:
            body = amount != 0 ? String(formattedNumber) : "-"
        case .none:
            body = amount != 0 ? String(formattedNumber) : "Not for sale"
        }
        
        let priceAttr = [NSAttributedString.Key.font :  UIFont.systemFont(ofSize: size, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.gold1]
        let finalString = NSMutableAttributedString(string: body, attributes: priceAttr as [NSAttributedString.Key : Any])
        
        let bodyString = NSMutableAttributedString(string: price.rawValue)
        
        
        bodyString.append(finalString)
        
        return bodyString
    }
}
