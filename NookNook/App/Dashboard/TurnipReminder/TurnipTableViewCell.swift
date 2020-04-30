 //
//  TurnipTableViewCell.swift
//  NookNook
//
//  Created by Kevin Laminto on 30/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class TurnipTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: false)
        switchView.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        accessoryView = switchView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc func valueChanged(sender: UISwitch) {
        print((textLabel?.text ?? "") + " switch is " + (sender.isOn ? "ON" : "OFF"))
    }
}
