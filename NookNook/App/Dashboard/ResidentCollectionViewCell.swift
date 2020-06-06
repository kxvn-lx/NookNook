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
    
    var villagerImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.sd_imageTransition = .fade
        v.sd_imageIndicator = SDWebImageActivityIndicator.gray
       return v
    }()
    var villagerName: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .center
        v.numberOfLines = 0
        v.textColor = .dirt1
       return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(villagerImage)
        self.addSubview(villagerName)

        villagerImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        villagerName.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(villagerImage.snp.bottom).offset(5)
        }
    }

    convenience init() {
        self.init(frame: CGRect())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
