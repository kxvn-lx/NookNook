//
//  NookTabBarController.swift
//  NookNook
//
//  Created by Kevin Laminto on 1/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class NookTabBarController: UITabBarController {

    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 0.9, 1.0]
        bounceAnimation.duration = TimeInterval(0.125)
        bounceAnimation.calculationMode = .cubic
        return bounceAnimation
    }()

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > idx + 1, let imageView = tabBar.subviews[idx + 1].subviews.compactMap({ $0 as? UIImageView }).first else {
            return
        }
        
        guard let idx1 = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > idx1 + 1, let textLabel = tabBar.subviews[idx1 + 1].subviews.compactMap({ $0 as? UILabel }).first else {
            return
        }

        imageView.layer.add(bounceAnimation, forKey: nil)
        textLabel.layer.add(bounceAnimation, forKey: nil)
    }

}
