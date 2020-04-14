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
    
    /**
     Parse the given URL and returns a URL format
     - Parameters:
        - imageID: The ID of the image
     - Returns:
        - The url of the image
     */
    static func parseURL(of imageID: String) -> URL {
        return URL(string: "\(ImageEngine.SERVICE_URL)\(imageID).png")!
    }
}
