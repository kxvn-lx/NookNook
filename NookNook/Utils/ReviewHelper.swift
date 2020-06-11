//
//  ReviewHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 9/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import StoreKit

class ReviewHelper {
    
    // Variables
    private let REVIEW_KEY = "NookNook.userDefaults.reviewKey"
    private let VERSION_KEY = "NookNook.userDefaults.versionKey"
    
    private var count: Int!
    private let defaults = UserDefaults.standard
    
    init() {
        count = defaults.integer(forKey: REVIEW_KEY)
        count += 1
        defaults.set(count, forKey: REVIEW_KEY)
    }
    
    /// Check whether the app can prompt user preview.
    /// Only presents the prompt if the user has opened the app 15 times, and has a new version.
    /// - Returns: Boolean of can review or not.
    func canReview() -> Bool {
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
            else { fatalError("Expected to find a bundle version in the info dictionary") }
        let lastVersionPromptedForReview = defaults.string(forKey: VERSION_KEY)
        print("ReviewHelper: App opened \(count ?? 0) time(s)")
        print("ReviewHelper: current bundle version: \(currentVersion)")
        
        if count == 15 && currentVersion != lastVersionPromptedForReview {
            defaults.set(currentVersion, forKey: VERSION_KEY)
            return true
        } else {
            return false
        }
    }
}
