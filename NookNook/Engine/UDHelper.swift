//
//  UDHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 23/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct UDHelper {
    
    private static let USER_KEY = "NookNook.userDefaults.key"
    private static let USER_AD_KEY = "NookNook.userDefaults.key.ad"
    private static let defaults = UserDefaults.standard
    
    private static var userDict: [String: String]!
    
    
    static func saveUser(user: User) {
        let saveUser = ["id": user.id,
                        "name": user.name,
                        "islandName": user.islandName,
                        "nativeFruit": user.nativeFruit,
                        "hemisphere": user.hemisphere.rawValue]
        defaults.set(saveUser, forKey: USER_KEY)
    }
    
    static func getUser() -> [String: String] {
        userDict = defaults.dictionary(forKey: USER_KEY) as? [String: String] ?? [String: String]()
        return userDict
    }
    
    
    /// Save user's bought preference
    static func saveIsAdsPurchased() {
        defaults.set(true, forKey: USER_AD_KEY)
    }
    
    /// Get user's ads bought preference
    static func getIsAdsPurchased() -> Bool {
        return defaults.bool(forKey: USER_AD_KEY)
    }
    
}
