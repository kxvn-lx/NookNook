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
    
    static func createSCWithTitle(title: String, items: [String]) -> UIView {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .callout)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        let vw = UIView()
        
        let sc = UISegmentedControl(items: items)
        sc.translatesAutoresizingMaskIntoConstraints = false
        
        let xPostion:CGFloat = 0
        let yPostion:CGFloat = 0
        let elementWidth:CGFloat = 300
        let elementHeight:CGFloat = 30
        
        sc.frame = CGRect(x: xPostion, y: yPostion, width: elementWidth, height: elementHeight)
        titleLabel.frame = CGRect(x: xPostion, y: yPostion, width: elementWidth, height: elementHeight)
        
        // Style the Segmented Control
        sc.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        sc.tintColor = UIColor(named: ColourUtil.cream1.rawValue)
        
        titleLabel.tag = 0
        sc.tag = 1
        
        vw.addSubview(titleLabel)
        vw.addSubview(sc)
        
        NSLayoutConstraint.activate([
            sc.centerXAnchor.constraint(equalTo: vw.centerXAnchor),
            sc.centerYAnchor.constraint(equalTo: vw.centerYAnchor, constant: -20),
            
            titleLabel.centerXAnchor.constraint(equalTo: vw.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: vw.centerYAnchor, constant: 20),
        ])
        
        return vw
    }
}
