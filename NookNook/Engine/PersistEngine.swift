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
    var critters: [Critter] = []
    var wardrobes: [Wardrobe] = []
    var villagers: [Villager] = []
    
    var categories: [String] = []
    
    struct SavedData: Codable {
        let items: [Item]
        let critters: [Critter]
        let wardrobes: [Wardrobe]
        let villagers: [Villager]
    }
    
    private let filePath: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        do {
            filePath = try FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent("favourites")
            if let data = try? Data(contentsOf: filePath) {
                decoder.dataDecodingStrategy = .base64
                let savedData = try decoder.decode(SavedData.self, from: data)
//                for item in savedData.items {
//                    if !categories.contains(item.category) {
//                        categories.append(item.category)
//                    }
//                }
                self.items = savedData.items
                self.critters = savedData.critters
                self.wardrobes = savedData.wardrobes
                self.villagers = savedData.villagers
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
    
    mutating func saveCritter(critter: Critter) {
        if critters.contains(critter) {
            critters.removeAll(where: { $0 == critter })
        } else {
            critters.append(critter)
        }
//        if !categories.contains(critter.category) {
//            categories.append(critter.category)
//        }
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
    
    mutating func saveVillager(villager: Villager) {
        if villagers.contains(villager) {
            villagers.removeAll(where: { $0 == villager })
        } else {
            villagers.append(villager)
        }
        save()
    }
    
    
    
    private func save() {
        do {
            let savedData = SavedData(items: items, critters: critters, wardrobes: wardrobes, villagers: villagers)
            let data = try encoder.encode(savedData)
            try data.write(to: filePath, options: .atomicWrite)
        } catch let error {
            print("Error while saving collection: \(error.localizedDescription)")
        }
        encoder.dataEncodingStrategy = .base64
    }
    
}
