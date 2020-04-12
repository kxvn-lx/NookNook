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
    
    static func parseURL(of imageID: String) -> URL {
        return URL(string: "\(ImageEngine.SERVICE_URL)\(imageID).png")!
    }
}
