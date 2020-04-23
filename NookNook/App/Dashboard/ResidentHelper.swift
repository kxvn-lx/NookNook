//
//  ResidentHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 23/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct ResidentHelper {
    
    private static let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    static func getMonthsBirthday(residents: [Villager]) -> [Villager] {
        var birthdayResident: [Villager] = []
        
        let date = Date()
        let calendar = Calendar.current
        let currMonth = months[calendar.component(.month, from: date) - 1]
        
        for resident in residents {
            let dateArr = resident.bdayString.components(separatedBy: " ")
            if currMonth == dateArr[0] {
                birthdayResident.append(resident)
            }
        }
        
        return birthdayResident
    }
}
