//
//  ResidentCollectionViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 19/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class ResidentCollectionViewCell: UICollectionViewCell {
    
    var villagerImage: UIImageView = UIImageView()
    var villagerName: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(villagerImage)
        self.addSubview(villagerName)
        
        villagerName.translatesAutoresizingMaskIntoConstraints = false
        villagerName.textAlignment = .center
        villagerName.numberOfLines = 0
        villagerName.textColor = .dirt1
        
        villagerImage.translatesAutoresizingMaskIntoConstraints = false
        villagerImage.sd_imageTransition = .fade
        villagerImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        NSLayoutConstraint.activate([
            villagerImage.topAnchor.constraint(equalTo: self.topAnchor),
            villagerImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            villagerImage.rightAnchor.constraint(equalTo: self.rightAnchor),
            villagerImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            villagerName.topAnchor.constraint(equalTo: villagerImage.bottomAnchor, constant: 5),
            villagerName.leftAnchor.constraint(equalTo: self.leftAnchor),
            villagerName.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }

    convenience init() {
        self.init(frame: CGRect())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
