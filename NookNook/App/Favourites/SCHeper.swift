//
//  SCHeper.swift
//  NookNook
//
//  Created by Kevin Laminto on 20/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct SCHelper {
    
    static func createSC(items: [String]) -> UIView {
        let vw = UIView()
        
        let sc = UISegmentedControl(items: items)
        sc.translatesAutoresizingMaskIntoConstraints = false
        
        let xPostion:CGFloat = 0
        let yPostion:CGFloat = 0
        let elementWidth:CGFloat = 300
        let elementHeight:CGFloat = 30
        
        sc.frame = CGRect(x: xPostion, y: yPostion, width: elementWidth, height: elementHeight)
        
        // Style the Segmented Control
        sc.layer.cornerRadius = 5.0
        sc.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        sc.tintColor = UIColor(named: ColourUtil.cream1.rawValue)
        
        sc.tag = 1
        
        
        vw.addSubview(sc)
        
        NSLayoutConstraint.activate([
            sc.centerXAnchor.constraint(equalTo: vw.centerXAnchor),
            sc.centerYAnchor.constraint(equalTo: vw.centerYAnchor)
        ])
        
        return vw
    }
}
