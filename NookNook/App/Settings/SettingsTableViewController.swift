//
//  SettingsTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 20/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

protocol ProfileDelegate: NSObjectProtocol {
    func updateprofile()
}

class SettingsTableViewController: UITableViewController {
    private var editInfoCell = UITableViewCell()
    private let EDIT_INFO_VC = "EditInfoVC"
    
    weak var profileDelegate: ProfileDelegate!
    
    private var shareCell = UITableViewCell()
    
    private var reportBugCell = UITableViewCell()
    private var deleteDatasCell = UITableViewCell()
    private var deleteCacheCell = UITableViewCell()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        setupConstraint()
        tableView.rowHeight = 50
        tableView.allowsSelection = true
        
         self.isModalInPresentation = true
    }
    
    override func loadView() {
        super.loadView()
        
        editInfoCell = setupCell(text: "Edit Info", icon:  IconUtil.systemIcon(of: .edit, weight: .regular), accesoryType: .disclosureIndicator)
        
        shareCell = setupCell(text: "Share", icon:  IconUtil.systemIcon(of: .share, weight: .regular), accesoryType: .disclosureIndicator)
        
        reportBugCell = setupCell(text: "Report a Bug", icon:  IconUtil.systemIcon(of: .bug, weight: .regular), accesoryType: .disclosureIndicator)
        
        deleteDatasCell  = setupCell(text: "Delete app data", icon:  IconUtil.systemIcon(of: .deleteData, weight: .regular), accesoryType: .none)
        deleteDatasCell.textLabel?.textColor = .red
        deleteDatasCell.imageView?.tintColor = .red
        
        deleteCacheCell  = setupCell(text: "Delete cached data", icon:  IconUtil.systemIcon(of: .deleteCache, weight: .regular), accesoryType: .none)
        deleteCacheCell.textLabel?.textColor = .red
        deleteCacheCell.imageView?.tintColor = .red
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
            return 2
        case 2:
            return 2
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
            case 1: return self.reportBugCell
            default: fatalError("Unknown row in section 1")
            }
            
        case 2:
            switch (indexPath.row) {
            case 0: return self.deleteCacheCell
            case 1: return self.deleteDatasCell
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
        case 2: return "Danger Zone"
        default: fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0: return ""
        case 1: return ""
        case 2: return "Delete cached data: The app will clear all cached images and could potentially could free up some space.\n\nDelete app data: The app will clear all stored favourites, donated/caught critters, and residents data. This could also free up some space."
        default: fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let vc = self.storyboard!.instantiateViewController(withIdentifier: EDIT_INFO_VC) as! EditInfoViewController
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated:true, completion: nil)
            default: fatalError("Invalid row")
            }
        case 1:
            switch indexPath.row {
            case 0: print(1)
            default: fatalError("Invalid row")
            }
        case 2:
            switch indexPath.row {
            case 0:
                let alertController = UIAlertController(title: "Delete cached datas?", message: "Cached images will be deleted and could free up some space in your device. This will exit the app.", preferredStyle: .alert)

                let destructiveAction = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
                    PersistEngine.deleteCacheData()
                    Taptic.successTaptic()
                    self.presentAlert()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                }

                alertController.addAction(destructiveAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            case 1:
                let alertController = UIAlertController(title: "Delete app datas?", message: "Your favourites, Donated/Caught, and residents data will be deleted. This will exit the app.", preferredStyle: .alert)

                let destructiveAction = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
                    PersistEngine.deleteAppData()
                    Taptic.successTaptic()
                    self.presentAlert()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                }

                alertController.addAction(destructiveAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            default: fatalError("Invalid row")
            }
        default:
            fatalError("Invalid sections")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    private func setBar() {
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Settings", preferredLargeTitle: true)
        
        self.view.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    @objc private func closeTapped() {
        if let profileDelegate = profileDelegate {
            profileDelegate.updateprofile()
        }
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
    
    private func presentAlert() {
        let alertController = UIAlertController(title: "Success!", message: "Please restart the app now so that the change is updated.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }

        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
