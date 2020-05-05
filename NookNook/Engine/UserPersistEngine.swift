//
//  UserPersistEngine.swift
//  NookNook
//
//  Created by Kevin Laminto on 23/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit


/// For user related settings (apart from UserDefaults)
struct UserPersistEngine {
    private static let IMAGE_NAME = "userImage"
    
    enum ReminderType: String {
        case buy = "userBuyReminder"
        case sell = "userSellReminder"
    }
    
    static func saveImage(image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        let fileName = IMAGE_NAME
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    static func loadImage() -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(IMAGE_NAME)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    
    
    static func saveReminder(timeDict: [Int: String], reminderType: ReminderType) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        let fileName = reminderType.rawValue
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        print("Saving user \(reminderType.rawValue) preference at: \(fileURL)")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: timeDict, requiringSecureCoding: false)
            try data.write(to: fileURL)
        } catch let error {
            print("Unable to save reminder with error: \(error.localizedDescription)")
        }
    }
    
    /// Save a user's reminder into the device.
    /// - Parameter reminderType: The type of reminder. Either buy or sell
    /// - Returns: A return of a random order of [2: "00", 1: "6", 0: "Friday", 3: "PM"] (best sort first)
    static func loadReminder(reminderType: ReminderType) -> [Int: String] {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        let fileName = reminderType.rawValue
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: fileURL)
            let timeDict = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Int: String]
            return timeDict
        } catch {
            print("Couldn't read file.")
        }
        return reminderType.rawValue == ReminderType.buy.rawValue ? [2: "00", 0: "Sunday", 3: "AM", 1: "6"] : [2: "00", 0: "Friday", 3: "PM", 1: "6"]
    }
}
