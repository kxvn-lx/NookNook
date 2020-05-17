//
//  SettingsTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 20/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

protocol ProfileDelegate: NSObjectProtocol {
    func updateprofile()
}

class SettingsTableViewController: UITableViewController {
    private let EDIT_INFO_VC = "EditInfoVC"
    private let PATCH_LOG_VC = "PatchLogVC"
    private let ADS_VC = "AdsVC"
    private let BUILD_NUMBER = "202005170"
    
    weak var profileDelegate: ProfileDelegate!
    
    private var editInfoCell = UITableViewCell()
    
    private var shareCell = UITableViewCell()
    private var creatorCell = UITableViewCell()
    private var websiteCell = UITableViewCell()
    
    private var requestFeatureCell = UITableViewCell()
    private var reportBugCell = UITableViewCell()
    private var appVersionCell = UITableViewCell()
    
    private var removeAdsCell = UITableViewCell()
    
    private var deleteDatasCell = UITableViewCell()
    private var deleteCacheCell = UITableViewCell()
    
    private let destColour = UIColor(red: 242/255, green: 67/255, blue: 51/255, alpha: 1)
    
    // MARK: - Tableview Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        
        self.isModalInPresentation = true
        
        self.setCustomFooterView(text: "Made with ❤️ by Kevin Laminto\n#NookNook", height: 50, multiplier: 1.5)
    }
    
    override func loadView() {
        super.loadView()
        
        editInfoCell = setupCell(text: "Edit info", icon: IconHelper.systemIcon(of: .edit, weight: .regular), accesoryType: .disclosureIndicator)
        
        shareCell = setupCell(text: "Share", icon: IconHelper.systemIcon(of: .share, weight: .regular), accesoryType: .disclosureIndicator)
        creatorCell = setupCell(text: "Creator", icon: IconHelper.systemIcon(of: .socialMedia, weight: .regular), accesoryType: .none)
        creatorCell.accessoryView = self.outsourceImageView()
        websiteCell = setupCell(text: "Website", icon: IconHelper.systemIcon(of: .website, weight: .regular), accesoryType: .none)
        websiteCell.accessoryView = self.outsourceImageView()
        
        requestFeatureCell = setupCell(text: "Request a feature", icon: IconHelper.systemIcon(of: .feature, weight: .regular), accesoryType: .disclosureIndicator)
        reportBugCell = setupCell(text: "Report a bug", icon: IconHelper.systemIcon(of: .bug, weight: .regular), accesoryType: .disclosureIndicator)
        appVersionCell = setupCell(text: "App version", icon: IconHelper.systemIcon(of: .info, weight: .regular), accesoryType: .disclosureIndicator)
        appVersionCell.detailTextLabel?.text = "\(UIApplication.appVersion!) (\(BUILD_NUMBER))"
        appVersionCell.detailTextLabel?.font = .preferredFont(forTextStyle: .caption1)
        
        deleteDatasCell  = setupCell(text: "Delete app data", icon: IconHelper.systemIcon(of: .deleteData, weight: .regular), accesoryType: .none)
        deleteDatasCell.textLabel?.textColor = destColour
        deleteDatasCell.imageView?.tintColor = destColour
        deleteCacheCell  = setupCell(text: "Delete cached data", icon: IconHelper.systemIcon(of: .deleteCache, weight: .regular), accesoryType: .none)
        deleteCacheCell.textLabel?.textColor = destColour
        deleteCacheCell.imageView?.tintColor = destColour

        removeAdsCell = setupCell(text: "Support me", icon: IconHelper.systemIcon(of: .supportMe, weight: .regular), accesoryType: .disclosureIndicator)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        case 2: return 3
        case 3: return 1
        case 4: return 2
        default: return 0
        }
    }
    
    // Return the row for the corresponding section and row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return self.editInfoCell
            default: fatalError("Unknown row in section 0")
            }
            
        case 1:
            switch indexPath.row {
            case 0: return self.shareCell
            case 1: return self.creatorCell
            case 2: return self.websiteCell
            default: fatalError("Unknown row in section 1")
            }
        case 2:
            switch indexPath.row {
            case 0: return self.requestFeatureCell
            case 1: return self.reportBugCell
            case 2: return self.appVersionCell
            default: fatalError("Unkown row in section 2")
            }
        case 3:
            switch indexPath.row {
            case 0: return self.removeAdsCell
            default: fatalError("Unknown row in section 3")
            }
        case 4:
            switch indexPath.row {
            case 0: return self.deleteCacheCell
            case 1: return self.deleteDatasCell
            default: fatalError("Unknown row in section 4")
            }
            
        default: fatalError("Unknown section")
        }
    }
    
    // Customize the section headings for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Share it if you love it."
        case 1: return ""
        case 2: return ""
        case 3: return ""
        case 4: return "Danger zone"
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            // Edit info
            case 0:
                let vc = self.storyboard!.instantiateViewController(withIdentifier: EDIT_INFO_VC) as! EditInfoViewController
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated: true, completion: nil)
            default: break
            }
        case 1:
            switch indexPath.row {
            // Share
            case 0: ShareHelper.shared.presentShare(toView: self)
            // Creator
            case 1:
                guard let url = URL(string: "https://twitter.com/kevinlx_")  else { return }
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            // Website
            case 2:
                guard let url = URL(string: "https://www.notion.so/NookNook-5983d18455354aea846999708a6045b1")  else { return }
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            default: break
            }
        case 2:
            switch indexPath.row {
            // Request a feature
            case 0:
                if MFMailComposeViewController.canSendMail() {
                    let mailVC = MFMailComposeViewController()
                    mailVC.mailComposeDelegate = self
                    mailVC.setToRecipients(["kevin.laminto@gmail.com"])
                    mailVC.setSubject("[NookNook] Feature request! 🚀")
                    mailVC.setMessageBody("Hi! I have a cool feature idea that could improve the app.", isHTML: false)
                    
                    present(mailVC, animated: true, completion: nil)
                } else {
                    let alert = AlertHelper.createDefaultAction(title: "No mail accounts", message: "Please configure a mail account in order to send email. Or, manually email it to kevin.laminto@gmail.com")
                    self.present(alert, animated: true)
                }
                
            // Report a bug
            case 1:
                if MFMailComposeViewController.canSendMail() {
                    let mailVC = MFMailComposeViewController()
                    mailVC.mailComposeDelegate = self
                    mailVC.setToRecipients(["kevin.laminto@gmail.com"])
                    mailVC.setSubject("[NookNook] Bug report! 🐜")
                    mailVC.setMessageBody("Hi! I found a bug.", isHTML: false)
                    
                    present(mailVC, animated: true, completion: nil)
                } else {
                    let alert = AlertHelper.createDefaultAction(title: "No mail accounts", message: "Please configure a mail account in order to send email. Or, manually email it to kevin.laminto@gmail.com")
                    self.present(alert, animated: true)
                }
                
            // App version
            case 2:
                let vc = self.storyboard!.instantiateViewController(withIdentifier: PATCH_LOG_VC) as! PatchLogViewController
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated: true, completion: nil)
            default: break
            }
        case 3:
            switch indexPath.row {
            // Remove ads
            case 0:
                let vc = self.storyboard!.instantiateViewController(withIdentifier: ADS_VC) as! InAppPurchaseViewController
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated: true, completion: nil)
            default: break
            }
        case 4:
            switch indexPath.row {
            // Delete cached data
            case 0:
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                    DataPersistEngine.deleteCacheData()
                    Taptic.successTaptic()
                    
                    let alert = AlertHelper.createDefaultAction(title: "Cached datas deleted.", message: "Please restart the app to ensure the changes have been applied.")
                    self.present(alert, animated: true)
                }
                let alert = AlertHelper.createCustomAction(title: "Delete cached datas?", message: "Cached images will be deleted. This could free up some space in your device", action: deleteAction)
                self.present(alert, animated: true)
                
            // Delete app data
            case 1:
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                    DataPersistEngine.deleteAppData()
                    Taptic.successTaptic()
                    
                    let alert = AlertHelper.createDefaultAction(title: "App datas deleted.", message: "Please restart the app to ensure the changes have been applied.")
                    self.present(alert, animated: true)
                }
                let alert = AlertHelper.createCustomAction(title: "Delete app datas?", message: "Your favourites, caught/donated, and in residents data will be deleted.", action: deleteAction)
                self.present(alert, animated: true)
                
            default: break
            }
        default:
            fatalError("Invalid sections")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        switch section {
        case 0: header.textLabel?.text! = "Share it if you love it."
        case 1: header.textLabel?.text! = ""
        case 2: header.textLabel?.text! = ""
        case 3: header.textLabel?.text! = ""
        case 4: header.textLabel?.text! = "Danger zone"
        default: header.textLabel?.text! = ""
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.detailTextLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
    }
    
    private func setBar() {
        self.configureNavigationBar(title: "Settings")
        self.view.backgroundColor = .cream1
        
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
        
        cell.backgroundColor = .cream2
        cell.imageView?.image = icon.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = .dirt1
        cell.textLabel?.text = text
        cell.textLabel?.textColor =  .dirt1
        cell.accessoryType = accesoryType
        
        return cell
    }
    
    private func outsourceImageView() -> UIImageView {
        let image = UIImage(systemName: "arrow.up.right")!.withRenderingMode(.alwaysTemplate)
        let v = UIImageView(image: image, highlightedImage: image)
        v.tintColor = .lightGray
        return v
    }
    
}

// MARK: - MFMail compose method
extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
