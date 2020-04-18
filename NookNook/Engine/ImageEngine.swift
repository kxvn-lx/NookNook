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
    private static let ACNH_API_URL = "http://acnhapi.com/"
    
    enum MediaType {
        case icons, images
    }
    
    /**
     Parse the given NookPlaza URL and returns a URL format
     - Parameters:
        - imageID: The ID of the image
     - Returns:
        - The url of the image
     */
    static func parseNPURL(with imageID: String) -> URL {
        return URL(string: "\(ImageEngine.SERVICE_URL)\(imageID).png")!
    }
    
    /**
     Parse the given ACNH-API URL and returns a URL format
     - Parameters:
        - imageID: The ID of the image
        - catType: The category of the image
        - mediaType: The type of the image (icons or images)
     - Returns:
        - The url of the image
     */
    static func parseAcnhURL(with imageID: String, of catType: String, mediaType: MediaType) -> URL {
        let catType = catType == Categories.fishes.rawValue ? "fish" : catType
        
        return URL(string: "\(ImageEngine.ACNH_API_URL)\(mediaType)/\(catType)/\(imageID)")!
    }
    
}
