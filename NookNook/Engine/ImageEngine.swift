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
}
