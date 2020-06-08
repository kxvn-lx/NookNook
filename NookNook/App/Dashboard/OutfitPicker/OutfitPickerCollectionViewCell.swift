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
    
    var label: UILabel = {
       let v = UILabel()
        v.backgroundColor = .cyan
        v.font = .preferredFont(forTextStyle: .caption1)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(imgView)
        addSubview(label)
        
        imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
        }
    }
}
