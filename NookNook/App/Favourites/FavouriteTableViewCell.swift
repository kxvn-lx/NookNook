//
//  FavouriteTableViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 20/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    private let MARGIN: CGFloat = 10
    
    var imgView: UIImageView!
    var tagLabel: UIButton!
    var nameLabel: UILabel!
    var label1 : UILabel!
    var label2: UILabel!
    var label3: UILabel!
    var label4: UILabel!
    
    var iconLabel1: PaddingLabel!
    var iconLabel2: PaddingLabel!
    
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
        tagLabel = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tagLabel.setTitleColor(.darkGray, for: .normal)
        tagLabel.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        tagLabel.isUserInteractionEnabled = false
        tagLabel.addBlurEffect(style: .light, cornerRadius: 5, padding: .zero)
        
        
        imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        
        
        iconLabel1 = PaddingLabel(withInsets: 2.5, 2.5, 5, 5)
        iconLabel1.translatesAutoresizingMaskIntoConstraints = false
        iconLabel1.numberOfLines = 0
        iconLabel1.font = UIFont.preferredFont(forTextStyle: .caption2)
        iconLabel1.font = UIFont.systemFont(ofSize: iconLabel1.font.pointSize, weight: .semibold)
        iconLabel1.textColor =  .white
        iconLabel1.layer.borderColor = UIColor(named: ColourUtil.gold1.rawValue)?.cgColor
        iconLabel1.backgroundColor = UIColor(named: ColourUtil.gold1.rawValue)
        iconLabel1.layer.borderWidth = 1
        iconLabel1.layer.cornerRadius = 5
        iconLabel1.clipsToBounds = true
        iconLabel1.textAlignment = .center
        
        iconLabel2 = PaddingLabel(withInsets: 2.5, 2.5, 5, 5)
        iconLabel2.translatesAutoresizingMaskIntoConstraints = false
        iconLabel2.numberOfLines = 0
        iconLabel2.font = UIFont.preferredFont(forTextStyle: .caption2)
        iconLabel2.font = UIFont.systemFont(ofSize: iconLabel2.font.pointSize, weight: .semibold)
        iconLabel2.textColor =  .white
        iconLabel2.layer.borderColor = UIColor(named: ColourUtil.grass2.rawValue)?.cgColor
        iconLabel2.backgroundColor = UIColor(named: ColourUtil.grass2.rawValue)
        iconLabel2.layer.borderWidth = 1
        iconLabel2.layer.cornerRadius = 5
        iconLabel2.clipsToBounds = true
        iconLabel2.textAlignment = .center

        
        imgView.addSubview(tagLabel)
//        imgView.addSubview(iconLabel1)
//        imgView.addSubview(iconLabel2)
        
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: nameLabel.font!.pointSize, weight: .semibold)
        nameLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        
        
        label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.numberOfLines = 0
        label1.font = UIFont.preferredFont(forTextStyle: .caption1)
        label1.textColor = .darkGray
        
        label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.numberOfLines = 0
        label2.font = UIFont.preferredFont(forTextStyle: .caption1)
        label2.textColor = .darkGray
        
        label4 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.numberOfLines = 0
        label4.font = UIFont.preferredFont(forTextStyle: .caption1)
        label4.textColor = .darkGray
        
        label3 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.numberOfLines = 0
        label3.font = UIFont.systemFont(ofSize: label4.font!.pointSize, weight: .semibold)
        label3.textColor = .darkGray
        
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
        
        bsStackView.addArrangedSubview(label3)
        bsStackView.addArrangedSubview(label4)
        
        infoStackView.isLayoutMarginsRelativeArrangement = true
        infoStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: MARGIN, leading: 0, bottom: 0, trailing: 0)
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(label1)
        infoStackView.addArrangedSubview(label2)
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
            
            tagLabel.leftAnchor.constraint(equalTo: imgView.leftAnchor),
            tagLabel.topAnchor.constraint(equalTo: imgView.topAnchor),
            
//            iconLabel1.rightAnchor.constraint(equalTo: imgView.rightAnchor),
//            iconLabel1.bottomAnchor.constraint(equalTo: imgView.bottomAnchor),
//
//            iconLabel2.bottomAnchor.constraint(equalTo: imgView.bottomAnchor),
//            iconLabel2.leftAnchor.constraint(equalTo: imgView.leftAnchor)
            
        ])
    }


}
