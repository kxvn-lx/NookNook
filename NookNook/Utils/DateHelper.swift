//
//  DateHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 22/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct DateHelper {
    
    private static let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    enum Seasons: String, Codable {
        case Spring, Summer, Fall, Winter
    }
    
    enum Hemisphere: String, Codable {
        case North, South
    }
    
    
    
    
    static func renderSeason(hemisphere: Hemisphere) -> Seasons {
        let isNorthern = hemisphere == Hemisphere.North
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let calendar = Calendar.current
        
        let currentMonth = calendar.component(.month, from: date)
        switch currentMonth {
        case 12,1,2 :
            return isNorthern ? .Winter : .Summer
        case 3,4,5 :
            return isNorthern ? .Spring : .Fall
        case 6, 7, 8:
            return isNorthern ? .Summer : .Winter
        case 9, 10, 11:
            return isNorthern ? .Fall : .Spring
        default:
            fatalError("Season index out of range")
        }
    }
    
    
    
    
    static func renderDate() -> String {
        var dateString = ""
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let calendar = Calendar.current
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        dateString = "\(months[calendar.component(.month, from: date) - 1]) \(formatter.string(from: NSNumber(value: calendar.component(.day, from: date)))!)"
        
        
        return dateString
    }
}
