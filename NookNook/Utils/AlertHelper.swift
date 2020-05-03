//
//  AlertHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 3/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct AlertHelper {
    
    /// Create a default action with only OK as the action
    /// - Parameters:
    ///   - title: The title of the action
    ///   - message: The message of the action
    /// - Returns: The alert ready to be presented
    static func createDefaultAction(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
    
    
    /// Create a custom action with the GO action as a custom
    /// - Parameters:
    ///   - title: The title of the action
    ///   - message: The message of the action
    ///   - action: The custom GO action. Usually to have an instruction if user press it.
    /// - Returns: The alert ready to be presented
    static func createCustomAction(title: String, message: String, action: UIAlertAction) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(action)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        return alert
    }
}
