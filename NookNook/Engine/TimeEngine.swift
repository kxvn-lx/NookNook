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
            
            finalTimeString = "\(sTime.clean) \(renderDelim(time: sTime)) - \(eTime.clean) \(renderDelim(time: eTime))"
        }
        else {
            fatalError("Unable to render time!")
        }

        
        return finalTimeString
    }
    
    private static func convertTime(with time: Float) -> Float {
        return time * 24
    }
    
    private static func renderDelim(time: Float) -> String {
        return time < 12 ? "AM" : "PM"
    }
}
