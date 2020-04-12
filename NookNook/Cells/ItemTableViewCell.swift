//
//  ItemTableViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 11/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    fileprivate let MARGIN: CGFloat = 10
    
    var isFavBtn: UIButton!
    var itemImageView: UIImageView!
    var itemNameLabel: UILabel!
    var obtainedFromLabel: UILabel!
    var buyLabel: UILabel!
    var sellLabel: UILabel!
    
    var mStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
        setupConstraint()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func setupView() {
        isFavBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        isFavBtn.translatesAutoresizingMaskIntoConstraints = false
        isFavBtn.backgroundColor = .green
        isFavBtn.setTitle("Star", for: .normal)
        isFavBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        itemImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.backgroundColor = .blue
        
        itemNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.numberOfLines = 0
        itemNameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
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
        
        mStackView = UIStackView()
        mStackView.alignment = .leading
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        mStackView.axis = .vertical
        mStackView.distribution = .fillProportionally
        mStackView.spacing = MARGIN
        
        let bsStackView = UIStackView()
        bsStackView.alignment = .leading
        bsStackView.translatesAutoresizingMaskIntoConstraints = false
        bsStackView.axis = .horizontal
        bsStackView.distribution = .equalCentering
        bsStackView.spacing = MARGIN
        
        bsStackView.addArrangedSubview(buyLabel)
        bsStackView.addArrangedSubview(sellLabel)
        
        
        mStackView.addArrangedSubview(itemNameLabel)
        mStackView.addArrangedSubview(obtainedFromLabel)
        mStackView.addArrangedSubview(bsStackView)
        
        
        
        
        self.addSubview(isFavBtn)
        self.addSubview(itemImageView)
        self.addSubview(mStackView)
    }
    
    fileprivate func setupConstraint() {
        NSLayoutConstraint.activate([
            isFavBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: MARGIN),
            isFavBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: MARGIN),
            isFavBtn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            isFavBtn.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            
            itemImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: MARGIN),
            itemImageView.leftAnchor.constraint(equalTo: isFavBtn.rightAnchor, constant: MARGIN),
            itemImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
            itemImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
            itemImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -MARGIN),
            
            mStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: MARGIN),
            mStackView.leftAnchor.constraint(equalTo: itemImageView.rightAnchor, constant: MARGIN),
            mStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -MARGIN),
            mStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -MARGIN)
        ])
    }
    
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
    }


}
