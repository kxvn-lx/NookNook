//
//  NotificationEngine.swift
//  NookNook
//
//  Created by Kevin Laminto on 1/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
import SwiftEntryKit

struct NotificationEngine {
    
    enum Identifier: String {
        case buy, sell
    }
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound]

    // MARK: - NotificationEngine methods
    
    /// RequestPermission method will check if the app has been granted permission or not.
    /// If not, display a meaningful message.
    func requestPermission() {
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                DispatchQueue.main.async {
                    let ( view, attributes ) = ModalFactory.showPopupMessage(title: "Oh no!", description: "NookNook can't send you reminders if you don't enable notifications. Please go to settings and enable it!", image: UIImage(named: "sad"))
                    SwiftEntryKit.display(entry: view, using: attributes)
                }
            }
        }
    }
    
    
    /// Create a local notification for later use.
    /// - Parameters:
    ///   - title: The title of the notification
    ///   - body: The body of the notification
    ///   - dateComponents: The time and day that the notification will be presented
    ///   - identifier: The unique identifier. This case, either buy or sell.
    func createNotification(title: String, body: String, dateComponents: DateComponents, identifier: Identifier) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier.rawValue, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
    
    
    /// Check wether the user has enabled a notifications (any pending notifications)
    /// - Parameters:
    ///   - identifer: The unique identifier. This case, either buy or sell
    ///   - completed: Async completion of true or false.
    func hasNotification(identifer: Identifier, completed: @escaping (Bool)-> Void = {_ in }) {
        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            var selectedNotifications: [UNNotificationRequest] = []
            requests.forEach({
                if $0.identifier == identifer.rawValue {
                    selectedNotifications.append($0)
                }
            })
            completed(selectedNotifications.count > 0)
        })
    }
    
    
}
