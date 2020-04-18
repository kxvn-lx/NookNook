//
//  PersistEngine.swift
//  NookNook
//
//  Created by Kevin Laminto on 17/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

// struct inspired from https://github.com/Dimillian/ACHNBrowserUI/blob/master/ACHNBrowserUI/ACHNBrowserUI/viewModels/CollectionViewModel.swift
struct PersistEngine {

    var items: [Item] = []
    
    var caughtCritters: [Critter] = []
    var donatedCritters: [Critter] = []
    
    var wardrobes: [Wardrobe] = []
    
    var favouritedVillagers: [Villager] = []
    var residentVillagers: [Villager] = []
    
    var categories: [String] = []
    
    struct SavedData: Codable {
        let items: [Item]
        
        let caughtCritters: [Critter]
        let donatedCritters: [Critter]
        
        let wardrobes: [Wardrobe]
        
        let favouritedVillagers: [Villager]
        let residentVillagers: [Villager]
    }
    
    private let filePath: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        do {
            filePath = try FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent("SavedDatas")
            if let data = try? Data(contentsOf: filePath) {
                decoder.dataDecodingStrategy = .base64
                let savedData = try decoder.decode(SavedData.self, from: data)
//                for item in savedData.items {
//                    if !categories.contains(item.category) {
//                        categories.append(item.category)
//                    }
//                }
                self.items = savedData.items
                
                self.caughtCritters = savedData.caughtCritters
                self.donatedCritters = savedData.donatedCritters
                
                self.wardrobes = savedData.wardrobes
                
                self.favouritedVillagers = savedData.favouritedVillagers
                self.residentVillagers = savedData.residentVillagers
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    mutating func saveItem(item: Item) {
        if items.contains(item) {
            items.removeAll(where: { $0 == item })
        } else {
            items.append(item)
        }
//        if !categories.contains(item.category) {
//            categories.append(item.category)
//        }
        save()
    }
    
    mutating func saveDonatedCritter(critter: Critter) {
        if donatedCritters.contains(critter) {
            donatedCritters.removeAll(where: {$0 == critter} )
        } else {
            donatedCritters.append(critter)
        }
        save()
    }
    
    mutating func saveCaughtCritter(critter: Critter) {
        if caughtCritters.contains(critter) {
            caughtCritters.removeAll(where: {$0 == critter} )
        } else {
            caughtCritters.append(critter)
        }
        save()
    }
    
    mutating func saveWardrobe(wardrobe: Wardrobe) {
        if wardrobes.contains(wardrobe) {
            wardrobes.removeAll(where: { $0 == wardrobe })
        } else {
            wardrobes.append(wardrobe)
        }
//        if !categories.contains(wardrobe.category) {
//            categories.append(wardrobe.category)
//        }
        save()
    }
    
    mutating func saveResidentVillager(villager: Villager) {
        if residentVillagers.contains(villager) {
            residentVillagers.removeAll(where: { $0 == villager })
        } else {
            residentVillagers.append(villager)
        }
        save()
    }
    
    mutating func saveFavouritedVillager(villager: Villager) {
        if favouritedVillagers.contains(villager) {
            favouritedVillagers.removeAll(where: {$0 == villager} )
        } else {
            favouritedVillagers.append(villager)
        }
        save()
    }
    
    
    
    private func save() {
        do {
            let savedData = SavedData(items: items, caughtCritters: caughtCritters, donatedCritters: donatedCritters, wardrobes: wardrobes, favouritedVillagers: favouritedVillagers, residentVillagers: residentVillagers)
            let data = try encoder.encode(savedData)
            try data.write(to: filePath, options: .atomicWrite)
        } catch let error {
            print("Error while saving collection: \(error.localizedDescription)")
        }
        encoder.dataEncodingStrategy = .base64
    }
    
}
