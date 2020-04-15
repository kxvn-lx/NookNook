//
//  CritterTableViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 14/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class CritterTableViewCell: UITableViewCell {
    
    private let MARGIN: CGFloat = 10
    
    var imgView: UIImageView!
    var rarityLabel: UIButton!
    var isFavImageView: UIImageView!
    var nameLabel: UILabel!
    var obtainedFromLabel : UILabel!
    var weatherLabel: UILabel!
    var timeLabel: UILabel!
    var sellLabel: UILabel!
    
    private var infoStackView: UIStackView!
    private var mStackView: UIStackView!
    private var iconStackView: UIStackView!

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
            
        
        rarityLabel = UIButton()
        rarityLabel.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rarityLabel.setTitleColor(.darkGray, for: .normal)
        rarityLabel.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        rarityLabel.isUserInteractionEnabled = false
        rarityLabel.addBlurEffect(style: .light, cornerRadius: 5, padding: .zero)
        
        isFavImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        isFavImageView.translatesAutoresizingMaskIntoConstraints = false
        isFavImageView.contentMode = .scaleAspectFit
        isFavImageView.tintColor = .darkGray
        
        iconStackView.addArrangedSubview(rarityLabel)
        iconStackView.addArrangedSubview(isFavImageView)
        
        imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        
        imgView.addSubview(iconStackView)
        
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: nameLabel.font!.pointSize, weight: .semibold)
        nameLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        
        obtainedFromLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        obtainedFromLabel.translatesAutoresizingMaskIntoConstraints = false
        obtainedFromLabel.numberOfLines = 0
        obtainedFromLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        obtainedFromLabel.textColor = .darkGray
        
        weatherLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.numberOfLines = 0
        weatherLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        weatherLabel.textColor = .darkGray
        
        timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.numberOfLines = 0
        timeLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        timeLabel.textColor = .darkGray
        
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
        mStackView.alignment = .leading
        mStackView.axis = .horizontal
        mStackView.distribution = .fill
        mStackView.spacing = MARGIN
        

        mStackView.addArrangedSubview(imgView)
        mStackView.addArrangedSubview(infoStackView)
        

        
        self.addSubview(mStackView)
    }
    
    private func setupConstraint() {
        let itemImageViewSize: CGFloat = 0.25
        let smallIconSize: CGFloat = itemImageViewSize / 6
        
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: itemImageViewSize),
            imgView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: itemImageViewSize),
            
            mStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: MARGIN),
            mStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: MARGIN),
            mStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -MARGIN),
            mStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -MARGIN),
            
            iconStackView.leftAnchor.constraint(equalTo: imgView.leftAnchor),
            iconStackView.topAnchor.constraint(equalTo: imgView.topAnchor),
            iconStackView.bottomAnchor.constraint(equalTo: imgView.bottomAnchor, constant: -MARGIN),
            
            isFavImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: smallIconSize),
            isFavImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: smallIconSize),
        ])
    }

}
