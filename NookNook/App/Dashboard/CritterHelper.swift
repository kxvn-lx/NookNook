//
//  CritterHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 23/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct CritterHelper {
    
    /**
     Method to calculate every critter that is available this month.
     - Parameters:
     - userHemisphere: The user's current hemisphere
     - Returns:
     Array Bugs and Fishes in the current hemisphere on this month.
     */
    static func parseCritter(userHemisphere: DateHelper.Hemisphere) -> ([Critter], [Critter]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        let currMonthInt = Int(dateFormatter.string(from: Date()))!
        
        
        var northernBugs: [Critter] = []
        var northernFishes: [Critter] = []
        
        var southernBugs: [Critter] = []
        var southernFishes: [Critter] = []
        
        let allBugs = DataEngine.loadCritterJSON(from: .bugsMain)
        let allFishes = DataEngine.loadCritterJSON(from: .fishesMain)
        
        switch userHemisphere {
        case .Northern:
            allBugs.forEach({
                let lowerBounds = TimeMonthEngine.formatMonths(month: $0.activeMonthsN) != [-1] ? TimeMonthEngine.formatMonths(month: $0.activeMonthsN).sorted(by: { $0 < $1 })[0] : -1
                let upperBounds = TimeMonthEngine.formatMonths(month: $0.activeMonthsN) != [-1] ? TimeMonthEngine.formatMonths(month: $0.activeMonthsN).sorted(by: { $0 < $1 }).last! : -1
                
                if (lowerBounds...upperBounds).contains(currMonthInt) || TimeMonthEngine.formatMonths(month: $0.activeMonthsN) == [-1] {
                    // bug is in season for northern region.
                    northernBugs.append($0)
                }
            })
            allFishes.forEach({
                let lowerBounds = TimeMonthEngine.formatMonths(month: $0.activeMonthsN) != [-1] ? TimeMonthEngine.formatMonths(month: $0.activeMonthsN).sorted(by: { $0 < $1 })[0] : -1
                let upperBounds = TimeMonthEngine.formatMonths(month: $0.activeMonthsN) != [-1] ? TimeMonthEngine.formatMonths(month: $0.activeMonthsN).sorted(by: { $0 < $1 }).last! : -1
                
                if (lowerBounds...upperBounds).contains(currMonthInt) || TimeMonthEngine.formatMonths(month: $0.activeMonthsN) == [-1] {
                    // fish is in season for northern region.
                    northernFishes.append($0)
                }
            })
        case .Southern:
            allBugs.forEach({
                let lowerBounds = TimeMonthEngine.formatMonths(month: $0.activeMonthsN) != [-1] ? TimeMonthEngine.formatMonths(month: $0.activeMonthsN).sorted(by: { $0 < $1 })[0] : -1
                let upperBounds = TimeMonthEngine.formatMonths(month: $0.activeMonthsN) != [-1] ? TimeMonthEngine.formatMonths(month: $0.activeMonthsN).sorted(by: { $0 < $1 }).last! : -1
                
                if (lowerBounds...upperBounds).contains(currMonthInt) || TimeMonthEngine.formatMonths(month: $0.activeMonthsS) == [-1] {
                    // bug is in season for northern region.
                    southernBugs.append($0)
                }
            })
            allFishes.forEach({
                let lowerBounds = TimeMonthEngine.formatMonths(month: $0.activeMonthsN) != [-1] ? TimeMonthEngine.formatMonths(month: $0.activeMonthsN).sorted(by: { $0 < $1 })[0] : -1
                let upperBounds = TimeMonthEngine.formatMonths(month: $0.activeMonthsN) != [-1] ? TimeMonthEngine.formatMonths(month: $0.activeMonthsN).sorted(by: { $0 < $1 }).last! : -1
                
                if (lowerBounds...upperBounds).contains(currMonthInt) || TimeMonthEngine.formatMonths(month: $0.activeMonthsS) == [-1] {
                    // fish is in season for northern region.
                    southernFishes.append($0)
                }
            })
        }
        
        switch userHemisphere {
        case .Northern:
            return (northernBugs, northernFishes)
        case .Southern:
            return (southernBugs, southernFishes)
        }
    }
    
    
    /**
     Method to calculate caught critters ONLY on this month
     - Parameters:
     - caughtBugs: The user's overall caught bugs
     - caughtFishes: The user's overall caught fishes
     - monthFishes: The current month's available fishes
     - monthBugs: The current month's available bugs
     */
    static func parseCaughtCritter(caughtBugs: [Critter], caughtFishes: [Critter], monthBugs: [Critter], monthFishes: [Critter]) -> ([Critter], [Critter]) {
        
        var caughtBugsMonth: [Critter] = []
        var caughtFishesMonth: [Critter] = []
        
        caughtBugs.forEach({
            if monthBugs.contains($0) {
                caughtBugsMonth.append($0)
            }
        })
        
        caughtFishes.forEach({
            if monthFishes.contains($0) {
                caughtFishesMonth.append($0)
            }
        })
        
        return ( caughtBugsMonth, caughtFishesMonth )
    }
}
