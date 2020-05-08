//
//  VariantCollectionViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 15/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class VariantCollectionViewCell: UICollectionViewCell {
    
    var variantImage: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(variantImage)
        variantImage.translatesAutoresizingMaskIntoConstraints = false
        variantImage.sd_imageTransition = .fade
        variantImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        NSLayoutConstraint.activate([
            variantImage.topAnchor.constraint(equalTo: self.topAnchor),
            variantImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            variantImage.rightAnchor.constraint(equalTo: self.rightAnchor),
            variantImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    convenience init() {
        self.init(frame: CGRect())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
