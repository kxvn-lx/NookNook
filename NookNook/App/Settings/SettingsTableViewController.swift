//
//  SettingsTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 20/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    private var editInfoCell = UITableViewCell()
    
    private var shareCell = UITableViewCell()
    
    private var reportBugCell = UITableViewCell()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        setupConstraint()
        tableView.rowHeight = 50
        tableView.allowsSelection = true
    }
    
    override func loadView() {
        super.loadView()
        
        editInfoCell = setupCell(text: "Edit Info", icon:  IconUtil.systemIcon(of: .edit, weight: .regular), accesoryType: .disclosureIndicator)
        
        shareCell = setupCell(text: "Share", icon:  IconUtil.systemIcon(of: .bug, weight: .regular), accesoryType: .disclosureIndicator)
        
        reportBugCell = setupCell(text: "Report a Bug", icon:  IconUtil.systemIcon(of: .share, weight: .regular), accesoryType: .disclosureIndicator)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    // Return the row for the corresponding section and row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return self.editInfoCell
            default: fatalError("Unknown row in section 0")
            }
            
        case 1:
            switch (indexPath.row) {
            case 0: return self.shareCell
            default: fatalError("Unknown row in section 1")
            }
            
        case 2:
            switch (indexPath.row) {
            case 0: return self.reportBugCell
            default: fatalError("Unknown row in section 2")
            }
            
        default: fatalError("Unknown section")
        }
    }
    
    // Customize the section headings for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Edit info"
        case 1: return ""
        case 2: return ""
        default: fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(indexPath.section)
        
    }
    

    private func setBar() {
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Settings", preferredLargeTitle: true)
        
        self.view.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
        ])
    }
    
    
    private func setupCell(text: String, icon: UIImage, accesoryType: UITableViewCell.AccessoryType) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
        cell.imageView?.image = icon.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = UIColor(named: ColourUtil.dirt1.rawValue)
        cell.textLabel?.text = text
        cell.textLabel?.textColor =  UIColor(named: ColourUtil.dirt1.rawValue)
        cell.accessoryType = accesoryType
        
        return cell
    }

}
