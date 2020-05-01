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
    
    var variantImage: UIImageView = UIImageView()
    var variantName: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(variantImage)
        self.addSubview(variantName)
        
        variantName.translatesAutoresizingMaskIntoConstraints = false
        variantName.textAlignment = .center
        variantName.numberOfLines = 0
        variantName.textColor = .dirt1
        
        variantImage.translatesAutoresizingMaskIntoConstraints = false
        variantImage.sd_imageTransition = .fade
        variantImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        NSLayoutConstraint.activate([
            variantImage.topAnchor.constraint(equalTo: self.topAnchor),
            variantImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            variantImage.rightAnchor.constraint(equalTo: self.rightAnchor),
            variantImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            variantName.topAnchor.constraint(equalTo: variantImage.bottomAnchor, constant: 5),
            variantName.leftAnchor.constraint(equalTo: self.leftAnchor),
            variantName.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }

    convenience init() {
        self.init(frame: CGRect())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
