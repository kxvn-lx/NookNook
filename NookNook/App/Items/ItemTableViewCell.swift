//
//  ItemTableViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 11/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SwipeCellKit
import SnapKit

class ItemTableViewCell: SwipeTableViewCell {
    
    private let MARGIN: CGFloat = 10
    
    var imgView: UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    var customisableImageView: UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.tintColor = .darkGray
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
    var obtainedFromLabel: UILabel = {
        let v = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.preferredFont(forTextStyle: .caption1)
        v.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        return v
    }()
    var buyLabel: UILabel = {
        let v = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.preferredFont(forTextStyle: .caption1)
        v.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        return v
    }()
    var sellLabel: UILabel = {
        let v = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = UIFont.preferredFont(forTextStyle: .caption1)
        v.textColor = UIColor.dirt1.withAlphaComponent(0.5)
       return v
    }()
    
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
        iconStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .leading, distribution: .equalCentering)
        iconStackView.addArrangedSubview(customisableImageView)
        iconStackView.addArrangedSubview(isFavImageView)
        
        imgView.addSubview(iconStackView)
        
        infoStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .leading, distribution: .fill)
        
        let bsStackView: UIStackView = SVHelper.createSV(axis: .horizontal, spacing: MARGIN, alignment: .leading, distribution: .fillEqually)
        
        bsStackView.addArrangedSubview(buyLabel)
        bsStackView.addArrangedSubview(sellLabel)
        
        infoStackView.isLayoutMarginsRelativeArrangement = true
        infoStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: MARGIN, leading: 0, bottom: 0, trailing: 0)
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(obtainedFromLabel)
        infoStackView.addArrangedSubview(bsStackView)
        
        mStackView = SVHelper.createSV(axis: .horizontal, spacing: MARGIN, alignment: .center, distribution: .fill)

        mStackView.addArrangedSubview(imgView)
        mStackView.addArrangedSubview(infoStackView)
        
        self.addSubview(mStackView)
    }
    
    private func setupConstraint() {
        let itemImageViewSize: CGFloat = 0.20
        let smallIconSize: CGFloat = itemImageViewSize / 6
        
        imgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.frame.width * itemImageViewSize)
        }
        
        mStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: MARGIN, left: MARGIN, bottom: MARGIN, right: MARGIN))
        }
        
        iconStackView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-MARGIN)
        }
        
        isFavImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.frame.width * smallIconSize)
        }
        
        customisableImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.frame.width * smallIconSize)
        }
    }
}
