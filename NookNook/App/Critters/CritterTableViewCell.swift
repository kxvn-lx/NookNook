//
//  CritterTableViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 14/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SwipeCellKit

class CritterTableViewCell: SwipeTableViewCell {
    
    private let MARGIN: CGFloat = 10
    
    var imgView: UIImageView!
    var rarityLabel: UIButton!
    var nameLabel: UILabel!
    var obtainedFromLabel: UILabel!
    var weatherLabel: UILabel!
    var timeLabel: UILabel!
    var sellLabel: UILabel!
    
    var isCaughtLabel: PaddingLabel!
    var isDonatedLabel: PaddingLabel!
    
    private var infoStackView: UIStackView!
    private var mStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        setupConstraint()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupView() {
        rarityLabel = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        rarityLabel.translatesAutoresizingMaskIntoConstraints = false
        rarityLabel.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rarityLabel.setTitleColor(.darkGray, for: .normal)
        rarityLabel.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        rarityLabel.isUserInteractionEnabled = false
        rarityLabel.addBlurEffect(style: .light, cornerRadius: 5, padding: .zero)
        
        imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        
        isCaughtLabel = PaddingLabel(withInsets: 2.5, 2.5, 5, 5)
        isCaughtLabel.translatesAutoresizingMaskIntoConstraints = false
        isCaughtLabel.numberOfLines = 0
        isCaughtLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        isCaughtLabel.font = UIFont.systemFont(ofSize: isCaughtLabel.font.pointSize, weight: .semibold)
        isCaughtLabel.textColor =  .white
        isCaughtLabel.layer.borderColor = UIColor.gold1.cgColor
        isCaughtLabel.backgroundColor = .gold1
        isCaughtLabel.layer.borderWidth = 1
        isCaughtLabel.layer.cornerRadius = 2.5
        isCaughtLabel.clipsToBounds = true
        isCaughtLabel.textAlignment = .center
        
        isDonatedLabel = PaddingLabel(withInsets: 2.5, 2.5, 5, 5)
        isDonatedLabel.translatesAutoresizingMaskIntoConstraints = false
        isDonatedLabel.numberOfLines = 0
        isDonatedLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        isDonatedLabel.font = UIFont.systemFont(ofSize: isDonatedLabel.font.pointSize, weight: .semibold)
        isDonatedLabel.textColor =  .white
        isDonatedLabel.layer.borderColor = UIColor.grass1.cgColor
        isDonatedLabel.backgroundColor = .grass1
        isDonatedLabel.layer.borderWidth = 1
        isDonatedLabel.layer.cornerRadius = 2.5
        isDonatedLabel.clipsToBounds = true
        isDonatedLabel.textAlignment = .center
        
        imgView.addSubview(rarityLabel)
        imgView.addSubview(isCaughtLabel)
        imgView.addSubview(isDonatedLabel)
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: nameLabel.font!.pointSize, weight: .semibold)
        nameLabel.textColor = .dirt1
        
        obtainedFromLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        obtainedFromLabel.translatesAutoresizingMaskIntoConstraints = false
        obtainedFromLabel.numberOfLines = 0
        obtainedFromLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        obtainedFromLabel.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        
        weatherLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.numberOfLines = 0
        weatherLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        weatherLabel.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        
        sellLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        sellLabel.translatesAutoresizingMaskIntoConstraints = false
        sellLabel.numberOfLines = 0
        sellLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        sellLabel.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        
        timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.numberOfLines = 0
        timeLabel.font = UIFont.systemFont(ofSize: sellLabel.font!.pointSize, weight: .semibold)
        timeLabel.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        
        infoStackView = UIStackView()
        infoStackView.alignment = .leading
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.distribution = .fill
        infoStackView.spacing = MARGIN
        
        let bsStackView = UIStackView()
        bsStackView.alignment = .center
        bsStackView.translatesAutoresizingMaskIntoConstraints = false
        bsStackView.axis = .horizontal
        bsStackView.distribution = .fillEqually
        bsStackView.spacing = MARGIN
        
        bsStackView.addArrangedSubview(timeLabel)
        bsStackView.addArrangedSubview(sellLabel)
        
        infoStackView.isLayoutMarginsRelativeArrangement = true
        infoStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: MARGIN, leading: 0, bottom: 0, trailing: 0)
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(obtainedFromLabel)
        infoStackView.addArrangedSubview(weatherLabel)
        infoStackView.addArrangedSubview(bsStackView)

        mStackView = UIStackView()
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        mStackView.alignment = .center
        mStackView.axis = .horizontal
        mStackView.distribution = .fill
        mStackView.spacing = MARGIN

        mStackView.addArrangedSubview(imgView)
        mStackView.addArrangedSubview(infoStackView)
        
        self.addSubview(mStackView)
    }
    
    private func setupConstraint() {
        let critterImageViewSize: CGFloat = 0.20
        
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: critterImageViewSize),
            imgView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: critterImageViewSize),
            
            mStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: MARGIN),
            mStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: MARGIN),
            mStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -MARGIN),
            mStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -MARGIN),
            
            rarityLabel.leftAnchor.constraint(equalTo: imgView.leftAnchor),
            rarityLabel.topAnchor.constraint(equalTo: imgView.topAnchor),
            
            isCaughtLabel.rightAnchor.constraint(equalTo: imgView.rightAnchor),
            isCaughtLabel.bottomAnchor.constraint(equalTo: imgView.bottomAnchor),
            
            isDonatedLabel.bottomAnchor.constraint(equalTo: imgView.bottomAnchor),
            isDonatedLabel.leftAnchor.constraint(equalTo: imgView.leftAnchor)
            
        ])
    }

}
