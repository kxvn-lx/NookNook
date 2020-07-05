//
//  GoogleAdsHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 4/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//
// app id: ca-app-pub-5887492549877876~7928146930

import Foundation

struct GoogleAdsHelper {
    
    enum AdsLocation: String {
        case items, critter, wardrobe, villager, dashboard, detail, category, crittersMonthly, favourites, turnipReminder, outfitPreview
        
        var id: String {
            switch self {
            case .items: return "ca-app-pub-5887492549877876/7634883291"
            case .dashboard: return "ca-app-pub-5887492549877876/6130229934"
            case .critter: return "ca-app-pub-5887492549877876/5391863338"
            case .detail: return "ca-app-pub-5887492549877876/6437351693"
            case .villager: return "ca-app-pub-5887492549877876/8756393275"
            case .wardrobe: return "ca-app-pub-5887492549877876/2382556616"
            case .category: return "ca-app-pub-5887492549877876/6146256392"
            case .crittersMonthly: return "ca-app-pub-5887492549877876/4258459651"
            case .favourites: return "ca-app-pub-5887492549877876/1855943005"
            case .turnipReminder: return "ca-app-pub-5887492549877876/9542861334"
            case .outfitPreview: return "ca-app-pub-5887492549877876/8941786607"
            }
        }
        
        var testId: String {
            return "ca-app-pub-3940256099942544/2934735716"
        }
    }
    
    private let IS_TEST = false
    static let shared = GoogleAdsHelper()
    private init() { }
    
    func getAds(forVC loc: AdsLocation) -> String {
        if IS_TEST {
            print("📑 Running test ads for \(loc.rawValue)")
            return loc.testId
        } else {
            print("📑 Running production ads for \(loc.rawValue)")
            return loc.id
        }
    }
    
}
