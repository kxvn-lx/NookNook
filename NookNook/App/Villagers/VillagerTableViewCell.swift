//
//  VillagerTableViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 17/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SwipeCellKit

class VillagerTableViewCell: SwipeTableViewCell {
    
    private let MARGIN: CGFloat = 10
    
    var imgView: UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    var personalityLabel: UIButton = {
        let v = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        v.setTitleColor(.darkGray, for: .normal)
        v.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        v.isUserInteractionEnabled = false
        v.addBlurEffect(style: .light, cornerRadius: 5, padding: .zero)
        return v
    }()
    var isFavImageView: UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.tintColor = .darkGray
        return v
    }()
    var nameLabel: UILabel = {
        let v = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.systemFont(ofSize: v.font!.pointSize, weight: .semibold)
        v.textColor = .dirt1
        return v
    }()
    var speciesLabel: UILabel = {
        let v = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.preferredFont(forTextStyle: .caption1)
        v.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        return v
    }()
    var bdayLabel: UILabel = {
        let v = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize, weight: .semibold)
        v.textColor =  UIColor.dirt1.withAlphaComponent(0.5)
        return v
    }()
    var genderLabel: UILabel = {
        let v = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.preferredFont(forTextStyle: .caption1)
        v.textColor =  UIColor.dirt1.withAlphaComponent(0.5)
        return v
    }()
    
    var isResidentLabel: UILabel = {
        let v = PaddingLabel(withInsets: 2.5, 2.5, 5, 5)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.preferredFont(forTextStyle: .caption2)
        v.font = UIFont.systemFont(ofSize: v.font.pointSize, weight: .semibold)
        v.textColor =  .white
        v.layer.borderColor = UIColor.gold1.cgColor
        v.backgroundColor = .gold1
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 2.5
        v.clipsToBounds = true
        v.textAlignment = .center
        return v
    }()
    
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
        
        imgView.addSubview(personalityLabel)
        imgView.addSubview(isFavImageView)
        imgView.addSubview(isResidentLabel)
        
        infoStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .leading, distribution: .fill)
        
        let bsStackView = SVHelper.createSV(axis: .horizontal, spacing: MARGIN, alignment: .center, distribution: .fillEqually)
        
        bsStackView.addArrangedSubview(bdayLabel)
        bsStackView.addArrangedSubview(genderLabel)
        
        infoStackView.isLayoutMarginsRelativeArrangement = true
        infoStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: MARGIN, leading: 0, bottom: 0, trailing: 0)
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(speciesLabel)
        infoStackView.addArrangedSubview(bsStackView)
        
        mStackView = SVHelper.createSV(axis: .horizontal, spacing: MARGIN, alignment: .center, distribution: .fill)
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mStackView.addArrangedSubview(imgView)
        mStackView.addArrangedSubview(infoStackView)
        
        self.addSubview(mStackView)
    }
    
    private func setupConstraint() {
        let villagerImageViewSize: CGFloat = 0.20
        let smallIconSize: CGFloat = villagerImageViewSize / 6

        imgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.frame.width * villagerImageViewSize)
        }
        
        mStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: MARGIN, left: MARGIN, bottom: MARGIN, right: MARGIN))
        }
        
        isFavImageView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.width.equalTo(self.frame.width * smallIconSize)
        }
        
        isResidentLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
        }
    }
    
}
