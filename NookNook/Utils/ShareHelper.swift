//
//  ShareHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 13/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct ShareHelper {
    
    private let URL_STRING = "https://cutt.ly/nooknook"
    
    static let shared = ShareHelper()
    
    private init() { }
    
    /// Present a default share sheet
    /// - Parameter sender: The view that will be presented the sheet is.
    func presentShare(toView sender: UIViewController) {
        let image = UIImage(named: "appIcon-Ori")
        let textToShare = "Check this app out! 😍 #NookNook"
        
        // http://itunes.apple.com/app/idXXXXXXXXX
        if let myWebsite = URL(string: URL_STRING) {
            let objectsToShare = [textToShare, myWebsite, image as Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.saveToCameraRoll]
            
            activityVC.popoverPresentationController?.sourceView = sender.view
            sender.present(activityVC, animated: true, completion: nil)
        }
    }
    
    /// Present a share context sheet
    /// - Parameters:
    ///   - obj: The object that will be shared
    ///   - group: The group origin of the object
    ///   - vc: The view controller that will present the sheet
    /// - Returns: The UI Menu ready to be presented
    func presentContextShare(obj: Any, group: DataEngine.Group, toVC vc: UIViewController) -> UIMenu {
        var name = ""
        let imageView = UIImageView()
        
        switch group {
        case .items:
            let item = obj as! Item
            name = item.name
            imageView.sd_setImage(with: ImageEngine.parseNPURL(with: item.image!, category: item.category), completed: nil)
        case .critters:
            let crit = obj as! Critter
            name = crit.name
            imageView.sd_setImage(with: ImageEngine.parseAcnhURL(with: crit.image, of: crit.category, mediaType: .images), completed: nil)
        case .wardrobes:
            let war = obj as! Wardrobe
            name = war.name
            imageView.sd_setImage(with: ImageEngine.parseNPURL(with: war.image!, category: war.category), completed: nil)
        case .villagers:
            let vill = obj as! Villager
            name = vill.name
            imageView.sd_setImage(with: ImageEngine.parseAcnhURL(with: vill.image, of: vill.category, mediaType: .images), completed: nil)
        }
        
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            let header = "Check \(name) on NookNook!"
            guard let url = URL(string: self.URL_STRING), let image = imageView.image else { return }
            let items = [header, image, url] as [Any]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            vc.present(ac, animated: true)
        }
        
        return UIMenu(title: "", children: [share])
        
    }
    
}
