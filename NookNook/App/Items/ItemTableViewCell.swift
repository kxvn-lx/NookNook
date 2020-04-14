//
//  ItemTableViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 11/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    private let MARGIN: CGFloat = 10
    
    var itemImageView: UIImageView!
    var customisableImageView: UIImageView!
    var isFavImageView: UIImageView!
    var itemNameLabel: UILabel!
    var obtainedFromLabel: UILabel!
    var buyLabel: UILabel!
    var sellLabel: UILabel!
    
    var infoStackView: UIStackView!
    var mStackView: UIStackView!
    var iconStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        setupConstraint()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupView() {
        iconStackView = UIStackView()
        iconStackView.translatesAutoresizingMaskIntoConstraints = false
        iconStackView.alignment = .leading
        iconStackView.axis = .vertical
        iconStackView.distribution = .equalCentering
        iconStackView.spacing = MARGIN
        
        customisableImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        customisableImageView.translatesAutoresizingMaskIntoConstraints = false
        customisableImageView.contentMode = .scaleAspectFit
        customisableImageView.tintColor = .darkGray
        
        isFavImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        isFavImageView.translatesAutoresizingMaskIntoConstraints = false
        isFavImageView.contentMode = .scaleAspectFit
        isFavImageView.tintColor = .darkGray
        
        iconStackView.addArrangedSubview(customisableImageView)
        iconStackView.addArrangedSubview(isFavImageView)
        
        itemImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.contentMode = .scaleAspectFit
        
        itemImageView.addSubview(iconStackView)
        
        
        itemNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.numberOfLines = 0
        itemNameLabel.font = UIFont.systemFont(ofSize: itemNameLabel.font!.pointSize, weight: .semibold)
        itemNameLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        
        obtainedFromLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        obtainedFromLabel.translatesAutoresizingMaskIntoConstraints = false
        obtainedFromLabel.numberOfLines = 0
        obtainedFromLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        obtainedFromLabel.textColor = .darkGray
        
        buyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        buyLabel.translatesAutoresizingMaskIntoConstraints = false
        buyLabel.numberOfLines = 0
        buyLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        buyLabel.textColor = .darkGray
        
        sellLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        sellLabel.translatesAutoresizingMaskIntoConstraints = false
        sellLabel.numberOfLines = 0
        sellLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        sellLabel.textColor = .darkGray
        
        infoStackView = UIStackView()
        infoStackView.alignment = .leading
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.distribution = .fill
        infoStackView.spacing = MARGIN
        
        let bsStackView = UIStackView()
        bsStackView.alignment = .leading
        bsStackView.translatesAutoresizingMaskIntoConstraints = false
        bsStackView.axis = .horizontal
        bsStackView.distribution = .equalSpacing
        bsStackView.spacing = MARGIN
        
        bsStackView.addArrangedSubview(buyLabel)
        bsStackView.addArrangedSubview(sellLabel)
        
        infoStackView.isLayoutMarginsRelativeArrangement = true
        infoStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: MARGIN, leading: 0, bottom: 0, trailing: 0)
        infoStackView.addArrangedSubview(itemNameLabel)
        infoStackView.addArrangedSubview(obtainedFromLabel)
        infoStackView.addArrangedSubview(bsStackView)

        mStackView = UIStackView()
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        mStackView.alignment = .leading
        mStackView.axis = .horizontal
        mStackView.distribution = .fill
        mStackView.spacing = MARGIN
        

        mStackView.addArrangedSubview(itemImageView)
        mStackView.addArrangedSubview(infoStackView)
        

        
        self.addSubview(mStackView)
    }
    
    private func setupConstraint() {
        let itemImageViewSize: CGFloat = 0.25
        let smallIconSize: CGFloat = itemImageViewSize / 6
        
        NSLayoutConstraint.activate([
            itemImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: itemImageViewSize),
            itemImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: itemImageViewSize),
            
            mStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: MARGIN),
            mStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: MARGIN),
            mStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -MARGIN),
            mStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -MARGIN),
            
            iconStackView.leftAnchor.constraint(equalTo: itemImageView.leftAnchor),
            iconStackView.topAnchor.constraint(equalTo: itemImageView.topAnchor),
            iconStackView.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: -MARGIN),
            
            isFavImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: smallIconSize),
            isFavImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: smallIconSize),
            
            customisableImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: smallIconSize),
            customisableImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: smallIconSize),
        ])
    }
    
    
    
}
