//
//  AppDelegate.swift
//  NookNook
//
//  Created by Kevin Laminto on 11/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import UXCam
import Firebase
import UserNotifications
import GoogleMobileAds
import SwiftyStoreKit
import SwiftyBeaver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let log = SwiftyBeaver.self
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        // MARK: - Analytics and ads configurations.
        UXCam.optIntoSchematicRecordings()
        UXCam.start(withKey: "pm7prng53jwfhag")
        
        FirebaseApp.configure()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = kGADSimulatorID as? [String]
        
        // Uncomment this to disable ads (Development purposes).
//        UDEngine.shared.saveIsAdsPurchased()
        
        // MARK: - SwiftyStoreKit
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred: break
                @unknown default:
                    fatalError("Unknown default")
                }
            }
        }
        
        // MARK: - Logger
        let console = ConsoleDestination()
        console.levelString.debug = "💚 DEBUG"
        console.levelString.info = "💙 INFO"
        console.levelString.warning = "💛 WARNING"
        console.levelString.error = "❤️ ERROR"
        
        let file = FileDestination()
        let cloud = SBPlatformDestination(appID: "XWx8zP", appSecret: "dvvJt6lrf9vw5rayifmh7b7kobnk8nYz", encryptionKey: "jxdzzroLusazn0pMxSsimUzj6Uvoe9h2")

        // use custom format and set console output to short time, log level & message
        console.format = "$DHH:mm:ss$d $L $M"
        
        log.addDestination(console)
        log.addDestination(file)
        log.addDestination(cloud)

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
