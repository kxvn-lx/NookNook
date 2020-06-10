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
    
    private var selectedOutfit: [Wardrobe] = []
    
    init(frame: CGRect, selectedOutfit: [Wardrobe]) {
        
        self.selectedOutfit = selectedOutfit
        
        super.init(frame: frame)
        
        setupView()
        setBar()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        logoImageView.alpha = 0.125
        addSubview(logoImageView)
        addSubview(mSV)
        
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
    
    private func setupConstraint() {
        logoImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        mSV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
    }
    
    private func setBar() {
        backgroundColor = .cream1
    }
}
