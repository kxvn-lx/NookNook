//
//  OutfitImageView.swift
//  NookNook
//
//  Created by Kevin Laminto on 9/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class OutfitImageView: UIView {

    private let logoImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "launchscreen")
        return v
    }()
    private let mSV = SVHelper.createSV(axis: .vertical, spacing: 5, alignment: .center, distribution: .equalSpacing)
    private let buttonSV = SVHelper.createSV(axis: .horizontal, spacing: 10, alignment: .center, distribution: .equalSpacing)
    private var saveButton: UIButton = {
        let v = UIButton()
        v.setTitle("Save to photo library", for: .normal)
        
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        v.backgroundColor = .grass1
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 2.5
        v.titleLabel?.numberOfLines = 2
        v.layer.borderColor = UIColor.grass1.cgColor
        v.titleLabel?.textAlignment = .center
        v.setTitleColor(UIColor.white, for: .normal)
        v.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        v.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        v.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .semibold)
        
        return v
    }()
    
    var selectedOutfit: [Wardrobe] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        logoImageView.alpha = 0.25
        addSubview(logoImageView)
        
        for outfit in selectedOutfit {
            let outfitImageView = UIImageView()
            outfitImageView.contentMode = .scaleAspectFit
            outfitImageView.sd_setImage(with: ImageEngine.parseNPURL(with: outfit.image!, category: outfit.category), placeholderImage: UIImage(named: "placeholder"))
            
            outfitImageView.snp.makeConstraints { (make) in
                make.height.width.equalTo(self.frame.width * 0.25)
            }
            
            mSV.addArrangedSubview(outfitImageView)
        }
    }
}
