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
    private let EDIT_INFO_VC = "EditInfoVC"
    private let PATCH_LOG_VC = "PatchLogVC"
    
    weak var profileDelegate: ProfileDelegate!
    
    private var editInfoCell = UITableViewCell()
    
    private var shareCell = UITableViewCell()
    private var twitCell = UITableViewCell()
    private var creatorCell = UITableViewCell()
    
    private var aboutCell = UITableViewCell()
    private var reportBugCell = UITableViewCell()
    private var appVersionCell = UITableViewCell()
    
    private var deleteDatasCell = UITableViewCell()
    private var deleteCacheCell = UITableViewCell()
    
    private let destColour = UIColor(red: 252/255, green: 63/255, blue: 56/255, alpha: 1)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.allowsSelection = true
        
         self.isModalInPresentation = true
    }
    
    override func loadView() {
        super.loadView()
        
        editInfoCell = setupCell(text: "Edit Info", icon:  IconUtil.systemIcon(of: .edit, weight: .regular), accesoryType: .disclosureIndicator)
        
        shareCell = setupCell(text: "Share", icon:  IconUtil.systemIcon(of: .share, weight: .regular), accesoryType: .disclosureIndicator)
        
        reportBugCell = setupCell(text: "Report a Bug", icon:  IconUtil.systemIcon(of: .bug, weight: .regular), accesoryType: .disclosureIndicator)
        
        deleteDatasCell  = setupCell(text: "Delete app data", icon:  IconUtil.systemIcon(of: .deleteData, weight: .regular), accesoryType: .none)
        deleteDatasCell.textLabel?.textColor = destColour
        deleteDatasCell.imageView?.tintColor = destColour
        
        deleteCacheCell  = setupCell(text: "Delete cached data", icon:  IconUtil.systemIcon(of: .deleteCache, weight: .regular), accesoryType: .none)
        deleteCacheCell.textLabel?.textColor = destColour
        deleteCacheCell.imageView?.tintColor = destColour
        
        creatorCell = setupCell(text: "Creator", icon: IconUtil.systemIcon(of: .socialMedia, weight: .regular), accesoryType: .disclosureIndicator)
        
        appVersionCell = setupCell(text: "App version", icon: IconUtil.systemIcon(of: .info, weight: .regular), accesoryType: .disclosureIndicator)
        appVersionCell.detailTextLabel?.text = "1.0.0"
        
        twitCell = setupCell(text: "Tweet it!", icon: IconUtil.systemIcon(of: .socialMedia, weight: .regular), accesoryType: .disclosureIndicator)
        
        aboutCell = setupCell(text: "About", icon: IconUtil.systemIcon(of: .about, weight: .regular), accesoryType: .disclosureIndicator)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 3
        case 3:
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
            case 1: return self.twitCell
            case 2: return self.creatorCell
            default: fatalError("Unknown row in section 1")
            }
        case 2:
            switch (indexPath.row) {
            case 0: return self.aboutCell
            case 1: return self.reportBugCell
            case 2: return self.appVersionCell
            default: fatalError("Unkown row ins ection 3")
            }
        case 3:
            switch (indexPath.row) {
            case 0: return self.deleteCacheCell
            case 1: return self.deleteDatasCell
            default: fatalError("Unknown row in section 4")
            }
            
        default: fatalError("Unknown section")
        }
    }
    
    // Customize the section headings for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return " "
        case 1: return "Share it if you ❤️ it."
        case 2: return ""
        case 3: return "Danger Zone"
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0: break
        case 1: break
        case 2: break
        case 3: return "Made with ❤️ by Kevin Laminto"
        default: return ""
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let vc = self.storyboard!.instantiateViewController(withIdentifier: EDIT_INFO_VC) as! EditInfoViewController
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated:true, completion: nil)
            default: break
            }
        case 1:
            switch indexPath.row {
            case 0: share(sender: self.view)
            case 1:
                guard let url = URL(string: "https://twitter.com/nooknook")  else { return }
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            case 2: print(1)
            default: break
            }
        case 2:
            switch indexPath.row {
            case 0: print("About VC")
            case 1: print(1)
            case 2:
                let vc = self.storyboard!.instantiateViewController(withIdentifier: PATCH_LOG_VC) as! PatchLogViewController
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated:true, completion: nil)
            default: break
            }
        case 3:
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
            default: break
            }
        default:
            fatalError("Invalid sections")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0, 1, 2: return 5
        default: return 35
        }
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
    
    private func setupCell(text: String, icon: UIImage, accesoryType: UITableViewCell.AccessoryType) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
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
    
    @objc func share(sender:UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let textToShare = "Animal Crossing: New Horizons is much better with this app! 😍"
        
        if let myWebsite = URL(string: "http://itunes.apple.com/app/idXXXXXXXXX") {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.saveToCameraRoll]
            
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }

}
