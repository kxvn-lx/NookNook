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
    private static var userDict: [String: String]!
    private static let defaults = UserDefaults.standard
    
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
    
}
