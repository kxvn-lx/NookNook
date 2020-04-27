//
//  WhatsNewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 27/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit
import WhatsNewKit

struct WhatsNewHelper {
    
    var whatsNewVC: WhatsNewViewController!
    
    // Initialiser
    init() {
        let whatsNew = WhatsNew(
            title: "WhatsNewKit",
            items: [
                WhatsNew.Item(
                    title: "Installation",
                    subtitle: "You can install WhatsNewKit via CocoaPods or Carthage",
                    image: UIImage(named: "installation")
                ),
                WhatsNew.Item(
                    title: "Open Source",
                    subtitle: "Contributions are very welcome 👨‍💻",
                    image: UIImage(named: "openSource")
                )
            ]
        )
        
        
        // Initialize WhatsNewViewController with WhatsNew
        whatsNewVC = WhatsNewViewController(
            whatsNew: whatsNew
        )
    }
}
