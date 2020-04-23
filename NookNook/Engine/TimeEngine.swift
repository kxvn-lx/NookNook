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
    
    private static let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
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
        - An array of month Int.
                - -1 means empty
                - -2 means function does not meet any requirements.
     */
    private static func formatMonths(month: String) -> [Int] {
        if month.isEmpty {
            return [-1]
        }
        
        if month.contains("&") {
            let monthArr = month.components(separatedBy: "&")
            let arr0 = monthArr[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let arr1 = monthArr[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            // check each arrays
            if arr0.contains("-") && arr1.contains("-") {
                let arr0Arr = formatHypenMonths(month: arr0)
                let arr1Arr = formatHypenMonths(month: arr1)
                return [arr0Arr[0], arr0Arr[1], arr1Arr[0], arr1Arr[1]]
            }
            
            if arr0.contains("-") {
                let arr0Arr = formatHypenMonths(month: arr0)
                return [arr0Arr[0], arr0Arr[1], Int(arr1)!]
            }
            
            if arr1.contains("-") {
                let arr1Arr = formatHypenMonths(month: arr1)
                return [arr1Arr[0], arr1Arr[1], Int(arr0)!]
            }
        }
        else {
            return formatHypenMonths(month: month)
        }
        
        return [-2]
    }
    
    
    private static func formatHypenMonths(month: String) -> [Int] {
        let month = month.trimmingCharacters(in: .whitespacesAndNewlines)
        if month.contains("-") {
            let monthArr = month.components(separatedBy: "-")
            return [Int(monthArr[0])!, Int(monthArr[1])!]
        }
        else {
            return [-2]
        }
    }
    
    /**
     Render a month format for better viewing. Since we only assume that Critters are the one dependent with time, this method is explicit for Critter object.
     - Parameters:
        - month: The month in Array of Int format.
     - Returns:
        - The month in sentence
     */
    static func renderMonth(monthInString month: String) -> String {
        let month = formatMonths(month: month)
        
        var renderedMonth = ""
        
        if month.contains(-1) {
            return "All day and night"
        }
        
        if month.contains(-2) {
            return "Season unknown"
        }
        
        if month.count == 1 {
            renderedMonth = "\(months[month[0] - 1])"
        }
        else if month.count == 2 {
            renderedMonth = "\(months[month[0] - 1]) to \(months[month[1] - 1])"
        }
        else if month.count == 3 {
            renderedMonth = "\(months[month[0] - 1]) to \(months[month[1] - 1]), and \(months[month[2] - 1])"
        }
        else if month.count == 4 {
            renderedMonth = "\(months[month[0] - 1]) to \(months[month[1] - 1]), and \(months[month[2] - 1]) to \(months[month[3] - 1])"
        }
        
        return renderedMonth
    }
    
}
