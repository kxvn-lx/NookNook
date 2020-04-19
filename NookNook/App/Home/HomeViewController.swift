//
//  HomeViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 11/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tbManager = tabBar.items {
            tbManager[0].title = "Items"
            tbManager[0].image = UIImage(systemName: "house")
            tbManager[0].selectedImage = UIImage(systemName: "hosue.fill")
            
            tbManager[1].title = "Critters"
            tbManager[1].image = UIImage(systemName: "ant")
            tbManager[1].selectedImage = UIImage(systemName: "ant.fill")
            
            tbManager[2].title = "Wardrobes"
            tbManager[2].image = UIImage(systemName: "briefcase")
            tbManager[2].selectedImage = UIImage(systemName: "briefcase.fill")
            
            tbManager[3].title = "Villagers"
            tbManager[3].image = UIImage(systemName: "person.2")
            tbManager[3].selectedImage = UIImage(systemName: "person.2.fill")
            
            tbManager[4].title = "Profile"
            tbManager[4].image = UIImage(systemName: "person.crop.circle")
            tbManager[4].selectedImage = UIImage(systemName: "person.crop.circle.fill")
        } else {
            fatalError("TabBar index out of bound.")
        }
    }
}
