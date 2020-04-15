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
     Render a time format
     - Parameters:
     - startTime: The start time in JSON format.
     - endTime: The end time in JSON format.
     - Returns:
     - A rendered value of time in String format.
     */
    static func renderTime(of startTime: JSON?, and endTime: JSON?) -> String {
        
        var finalTimeString = ""
        
        
        
        guard let startTime = startTime?.stringValue, let endTime = endTime?.stringValue else {
            finalTimeString = "Error"
            return finalTimeString
        }
        
        if startTime == "All day" && endTime == "All day" {
            finalTimeString = "All day"
        }
        else if startTime.contains("\n") && endTime.contains("\n") {
            finalTimeString = "Multiple times"
        }
        else if startTime.isFloat && endTime.isFloat {
            let sTime = convertTime(with: Float(startTime)!)
            let eTime = convertTime(with: Float(endTime)!)
            
            finalTimeString = "\(renderTime(sTime).clean) \(renderDelim(time: sTime)) - \(renderTime(eTime).clean) \(renderDelim(time: eTime))"
        }
        else {
            fatalError("Unable to render time!")
        }
        
        
        return finalTimeString
    }
    
    /**
     Render a month format
     - Parameters:
     
     - Returns:
     - A rendered value of months in String format.
     */
    static func renderMonths(with monthSpan: [Int]) -> String {
        let months = [
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
            "Dec"
        ]
        return "\(months[monthSpan.first!]) - \(months.last!)"
    }
    
    private static func convertTime(with time: Float) -> Float {
        return time * 24
    }
    
    private static func renderDelim(time: Float) -> String {
        return time < 12 ? "AM" : "PM"
    }
    
    private static func renderTime(_ time: Float) -> Float {
        return time > 12 ? time - 12 : time
    }
}
