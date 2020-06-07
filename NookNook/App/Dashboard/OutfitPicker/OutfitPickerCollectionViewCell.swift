//
//  OutfitPickerCollectionViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 7/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class OutfitPickerCollectionViewCell: UICollectionViewCell {
    
    var imgView: UIImageView = {
       let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.sd_imageTransition = .fade
        v.sd_imageIndicator = SDWebImageActivityIndicator.gray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imgView)
        
        imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    convenience init() {
        self.init(frame: CGRect())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
