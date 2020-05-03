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

struct NotificationEngine {
    
    enum Identifier: String {
        case buy, sell
    }
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound]

    // MARK: - NotificationEngine methods
    
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
    
    
    /// Quick check if the app has access for notifications
    /// - Parameter status: the status completion
    func checkStatus(status: @escaping (Bool) -> Void = {_ in }) {
        notificationCenter.getNotificationSettings { (settings) in
          if settings.authorizationStatus != .authorized {
            status(false)
          }
        }
    }
}
