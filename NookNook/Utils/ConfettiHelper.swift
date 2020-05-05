//
//  ConfettiHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 5/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit
import SwiftConfettiView

struct ConfettiHelper {
    
    static let shared = ConfettiHelper()
    
    private init() { }
    
    func renderConfetti(toView view: UIView, withType type: SwiftConfettiView.ConfettiType) -> SwiftConfettiView {
        let confettiView = SwiftConfettiView(frame: view.bounds)
        confettiView.type = type
        confettiView.intensity = 0.5
        confettiView.isUserInteractionEnabled = false
        
        return confettiView
    }
}
