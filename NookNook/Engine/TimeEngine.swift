//
//  TimeEngine.swift
//  NookNook
//
//  Created by Kevin Laminto on 15/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct TimeEngine {
    
    /**
     Render a time format for better viewing. Since we only assume that Critters are the one dependent with time, this method is explicit for Critter object.
     - Parameters:
        - time: The time in string format.
     - Returns:
        - The rendered formatted time
     */
    static func formatTime(of time: String) -> String {
        
        var renderedTime = ""
        
        if time.contains("-") {
            let timeArr = time.components(separatedBy: " - ")
            renderedTime = "\(timeArr[0].uppercased()) - \(timeArr[1].uppercased())"
        }
        else if time.contains("to") {
            let timeArr = time.components(separatedBy: " to ")
            renderedTime = "\(timeArr[0].uppercased()) - \(timeArr[1].uppercased())"
        }
        else if time.isEmpty {
            renderedTime = "All day"
        }
        else {
            print(time)
            fatalError("Unable to format time!")
        }
        
        return renderedTime
    }
    
    
    /**
     Render a month format for better viewing. Since we only assume that Critters are the one dependent with time, this method is explicit for Critter object.
     - Parameters:
        - month: The month in string format.
     - Returns:
        - The rendered formatted time
     */
    static func formatMonth(of month: String) -> String {
        let monthNames = [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec",
        ]
        
        var renderedMonth = ""
        
        if month.contains("-") {
            let monthArr = month.components(separatedBy: "-")
            renderedMonth = "\(monthNames[Int(monthArr[0])! - 1]) - \(monthNames[Int(monthArr[1])! - 1])"
        }
        else if month.isEmpty {
            renderedMonth = "All Seasons"
        }
        else {
            print(month)
            fatalError("Unable to format months!")
        }
        
        return renderedMonth
    }
}
