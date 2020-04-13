//
//  CategoryTableViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 13/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    private let MARGIN: CGFloat = 10
    
    var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        setupConstraint()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupView() {
        categoryNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryNameLabel.numberOfLines = 0
        categoryNameLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        
        self.addSubview(categoryNameLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            categoryNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: MARGIN),
            categoryNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: MARGIN),
            categoryNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -MARGIN),
        ])
    }
}
