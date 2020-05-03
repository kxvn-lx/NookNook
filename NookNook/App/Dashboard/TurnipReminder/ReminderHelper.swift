//
//  ReminderHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 2/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit
import McPicker

struct ReminderHelper {
    
    static var days: [String] = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    private var hours: [String] = []
    private var minutes: [String] = []
    private var period: [String] = ["AM","PM"]
    
    private var mcPicker: McPicker!
    
    init() {
        for i in (1...12) {
            self.hours.append(String(i))
        }
        for i in (0...59) {
            self.minutes.append(String(format: "%02d", i))
        }
    }
    
    
    /// Get all the Day and Time in one single ararys of arrays
    /// - Returns: An array of String arrays
    private func getDateTimeArray() -> [[String]] {
        var array:[[String]] = []
        
        array.append(ReminderHelper.days)
        array.append(hours)
        array.append(minutes)
        array.append(period)
        
        return array
    }
    
    
    /// Create a custom McPicker and populates it with the data
    /// - Returns: The customised McPicker complete with its data
    mutating func createMcPicker(selections: [Int: String]? = nil, reminderType: UserPersistEngine.ReminderType) -> McPicker {
        
        let buySelected = [
            0: [5: true],
            1: [5: true],
            2: [0: true],
            3: [0: true],
        ]
        
        let sellSelected = [
            0: [0: true],
            1: [5: true],
            2: [0: true],
            3: [1: true],
        ]
        
        
        var selected: [Int: [Int:Bool]] = reminderType == UserPersistEngine.ReminderType.buy ? buySelected : sellSelected
        if let selections = selections {
            selected = convertToRawSelection(selections: selections)
        }
        
        
        
        var data: [[String]] = []
        data = getDateTimeArray()
        
        mcPicker = McPicker(data: data)
        
        let font = UIFont.preferredFont(forTextStyle: .body)
        mcPicker.fontSize = font.pointSize
        
        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let doneButton = McPickerBarButtonItem.done(mcPicker: mcPicker)
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel)
        // Set custom toolbar items
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, doneButton, fixedSpace])
        
        mcPicker.toolbarItemsFont = .preferredFont(forTextStyle: .body)
        mcPicker.toolbarButtonsColor = .dirt1
        mcPicker.toolbarBarTintColor = .cream1
        mcPicker.backgroundColor = UIColor(white: 0/255.0, alpha: 0.3)
        mcPicker.pickerBackgroundColor = .cream1
        mcPicker.pickerSelectRowsForComponents = selected
        
        
        
        return mcPicker
    }
    
    
    /// Render a time in [Int: String] into a readable String
    /// - Parameter timeDict: The raw timeDict format from McPicker
    /// - Returns: The readable from in DAY (H:MMmm) format.
    func renderTime(timeDict: [Int: String]) -> String {
        
        let timeDict = timeDict.sorted(by: { $0 < $1 })
        let day = timeDict[0].value
        let hour = timeDict[1].value
        let min = timeDict[2].value
        let meridian = timeDict[3].value
        
        let time = "\(day) (\(hour):\(min)\(meridian))"
        
        return time
    }
    
    
    
    /// Convert the function into a raw selection to be parsed for McPicker selections
    private func convertToRawSelection(selections: [Int: String]) -> [Int: [Int: Bool]] {
        
        let timeDict = selections.sorted(by: { $0 < $1 }) // 0: Day, 1: Hour, 2: Min, 3: Meridian
        
        let dayInt = ReminderHelper.days.firstIndex(of: timeDict[0].value)
        let hourInt = Int(timeDict[1].value)! - 1
        let minInt = timeDict[2].value.prefix(1) == "0" ? Int(timeDict[2].value.suffix(1))! : Int(timeDict[2].value)!
        let merInt = timeDict[3].value == "AM" ? 0 : 1
        
        let selectComponents: [Int: [Int:Bool]] = [
            0: [dayInt!: true],
            1: [hourInt: true],
            2: [minInt: true],
            3: [merInt: true],
        ]
        
        return selectComponents
    }
    
    
}
