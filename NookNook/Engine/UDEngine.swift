//
//  UDEngine.swift
//  NookNook
//
//  Created by Kevin Laminto on 23/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct UDEngine {
    
    enum Key: String {
        case UserData = "NookNook.userDefaults.key"
        case Ad = "NookNook.userDefaults.key.ad"
        case FirstVisit = "NookNook.userDefaults.key.firstVisit"
        case CrittersCompleted = "NookNook.userDefaults.key.crittersCompleted"
    }
    
    enum TableViewCaller: String {
        case Item, Critters, Wardrobes, Villagers, CrittersThisMonth
    }
    
    private init() { }
    static let shared = UDEngine()
    
    private let defaults = UserDefaults.standard
    
    
    // MARK: - Get user's data
    func saveUser(user: User) {
        let saveUser = ["id": user.id,
                        "name": user.name,
                        "islandName": user.islandName,
                        "nativeFruit": user.nativeFruit,
                        "hemisphere": user.hemisphere.rawValue]
        defaults.set(saveUser, forKey: Key.UserData.rawValue)
    }
    
    func getUser() -> [String: String] {
        return defaults.dictionary(forKey:  Key.UserData.rawValue) as? [String: String] ?? [String: String]()
    }
    
    
    // MARK: - Has purchased ads
    /// Save user's bought preference
    func saveIsAdsPurchased() {
        defaults.set(true, forKey: Key.Ad.rawValue)
    }
    
    /// Get user's ads bought preference
    func getIsAdsPurchased() -> Bool {
        return defaults.bool(forKey: Key.Ad.rawValue)
    }
    
    
    // MARK: - Is first Visit
    func saveIsFirstVisit(on vc: TableViewCaller) {
        defaults.set(true, forKey: Key.FirstVisit.rawValue + vc.rawValue)
    }
    
    func getIsFirstVisit(on vc: TableViewCaller) -> Bool {
        return defaults.bool(forKey: Key.FirstVisit.rawValue + vc.rawValue)
    }
    
    
    // MARK: - Has completed Critters
    func saveHasCompletedCritters(isCompleted bool: Bool) {
        defaults.set(bool, forKey: Key.CrittersCompleted.rawValue)
    }
    
    func getHasCompletedCritters() -> Bool {
        return defaults.bool(forKey: Key.CrittersCompleted.rawValue)
    }
    
}
