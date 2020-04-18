//
//  VillagerTableViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 17/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class VillagerTableViewCell: UITableViewCell {
    
    private let MARGIN: CGFloat = 10
    
    var imgView: UIImageView!
    var personalityLabel: UIButton!
    var isFavImageView: UIImageView!
    var nameLabel: UILabel!
    var speciesLabel : UILabel!
    var bdayLabel: UILabel!
    var genderLabel: UILabel!
    
    var isResidentLabel: UILabel!
    
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
        personalityLabel = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        personalityLabel.translatesAutoresizingMaskIntoConstraints = false
        personalityLabel.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        personalityLabel.setTitleColor(.darkGray, for: .normal)
        personalityLabel.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        personalityLabel.isUserInteractionEnabled = false
        personalityLabel.addBlurEffect(style: .light, cornerRadius: 5, padding: .zero)
        
        imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        
        isResidentLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        isResidentLabel.textColor = .darkGray
        isResidentLabel.translatesAutoresizingMaskIntoConstraints = false
        isResidentLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        isResidentLabel.font = UIFont.systemFont(ofSize: isResidentLabel.font.pointSize, weight: .black)
        
        isFavImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        isFavImageView.translatesAutoresizingMaskIntoConstraints = false
        isFavImageView.contentMode = .scaleAspectFit
        isFavImageView.tintColor = .darkGray
        
        
        imgView.addSubview(personalityLabel)
        imgView.addSubview(isFavImageView)
        imgView.addSubview(isResidentLabel)
        
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: nameLabel.font!.pointSize, weight: .semibold)
        nameLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        
        speciesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        speciesLabel.translatesAutoresizingMaskIntoConstraints = false
        speciesLabel.numberOfLines = 0
        speciesLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        speciesLabel.textColor = .darkGray
        
        genderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.numberOfLines = 0
        genderLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        genderLabel.textColor = .darkGray
        
        bdayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        bdayLabel.translatesAutoresizingMaskIntoConstraints = false
        bdayLabel.numberOfLines = 0
        bdayLabel.font = UIFont.systemFont(ofSize: genderLabel.font!.pointSize, weight: .semibold)
        bdayLabel.textColor = .darkGray
        
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
        bsStackView.distribution = .equalSpacing
        bsStackView.spacing = MARGIN
        
        bsStackView.addArrangedSubview(bdayLabel)
        bsStackView.addArrangedSubview(genderLabel)
        
        infoStackView.isLayoutMarginsRelativeArrangement = true
        infoStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: MARGIN, leading: 0, bottom: 0, trailing: 0)
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(speciesLabel)
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
        let villagerImageViewSize: CGFloat = 0.20
        let smallIconSize: CGFloat = villagerImageViewSize / 6
        
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: villagerImageViewSize),
            imgView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: villagerImageViewSize),
            
            mStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: MARGIN),
            mStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: MARGIN),
            mStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -MARGIN),
            mStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -MARGIN),
            
            personalityLabel.leftAnchor.constraint(equalTo: imgView.leftAnchor),
            personalityLabel.topAnchor.constraint(equalTo: imgView.topAnchor),
            
            isFavImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: smallIconSize),
            isFavImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: smallIconSize),
            
            isFavImageView.leftAnchor.constraint(equalTo: imgView.leftAnchor),
            isFavImageView.bottomAnchor.constraint(equalTo: imgView.bottomAnchor),
            
            isResidentLabel.rightAnchor.constraint(equalTo: imgView.rightAnchor),
            isResidentLabel.bottomAnchor.constraint(equalTo: imgView.bottomAnchor)
        ])
    }

}
