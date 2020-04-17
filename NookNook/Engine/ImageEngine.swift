//
//  ImageEngine.swift
//  NookNook
//
//  Created by Kevin Laminto on 12/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct ImageEngine {
    
    private static let SERVICE_URL = "https://i.imgur.com/"
    private static let ACNH_API_URL = "http://acnhapi.com/images/"
    private static let ACNH_VILLAGER_API_URL = "http://acnhapi.com/icons/villagers/"
    
    /**
     Parse the given URL and returns a URL format
     - Parameters:
        - imageID: The ID of the image
     - Returns:
        - The url of the image
     */
    static func parseURL(with imageID: String) -> URL {
        return URL(string: "\(ImageEngine.SERVICE_URL)\(imageID).png")!
    }
    
    /**
     Parse the given ACNH URL and returns a URL format
     - Parameters:
        - imageID: The ID of the image
     - Returns:
        - The url of the image
     */
    static func parseAcnhURL(with imageID: String, of critterType: String) -> URL {
        var type = Categories.bugs.rawValue
        if critterType == Categories.fishes.rawValue {
            type = "Fish"
        }
        
        return URL(string: "\(ImageEngine.ACNH_API_URL)\(type)/\(imageID)")!
    }
    
    /**
     Parse the given ACNH URL and returns a URL format (Villagers only)
     - Parameters:
        - imageID: The ID of the image
        - mediaType: Icon(0) or Image(1)
     - Returns:
        - The url of the image
     */
    static func parseVillagerURL(with imageID: String, of mediaType: Int) -> URL {
        
        switch mediaType {
            // Icon
        case 0:
            return URL(string: "\(ImageEngine.ACNH_VILLAGER_API_URL)\(imageID)")!
            
            // Image
        case 1:
            return URL(string: "\(ImageEngine.ACNH_API_URL)villagers/\(imageID)")!
        default:
            fatalError("mediaType is only 0 or 1!")
        }
        
        
    }
    
}
