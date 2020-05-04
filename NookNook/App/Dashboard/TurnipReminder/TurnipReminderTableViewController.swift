//
//  TurnipReminderTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 30/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import UserNotifications
import McPicker
import GoogleMobileAds

class TurnipReminderTableViewController: UITableViewController {
    
    lazy private var buyCell = TurnipTableViewCell()
    lazy private var sellCell = TurnipTableViewCell()
    
    lazy private var customBuyCell = UITableViewCell()
    lazy private var customSellCell = UITableViewCell()
    
    
    lazy private var notificationsManager = NotificationEngine()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound]
    
    lazy private var dayTimeHelper = ReminderHelper()
    private var mcPicker: McPicker!
    
    
    private var buyLabel = "Sunday (06:00AM)"
    private var sellLabel = "Friday (06:00PM)"
    
    // Google ads banner
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
        adBannerView.translatesAutoresizingMaskIntoConstraints = false
        adBannerView.adUnitID = GoogleAdsHelper.AD_UNIT_ID
        adBannerView.delegate = self
        adBannerView.rootViewController = self

        return adBannerView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        
        buyLabel = dayTimeHelper.renderTime(timeDict: UserPersistEngine.loadReminder(reminderType: .buy))
        sellLabel = dayTimeHelper.renderTime(timeDict: UserPersistEngine.loadReminder(reminderType: .sell))
        
        // Setup google ads
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "2077ef9a63d2b398840261c8221a0c9b" ]
    }
    
    override func loadView() {
        super.loadView()
        
        buyCell = setupToggleCell(text: "Buy reminder")
        buyCell.selectionStyle = .none
        notificationsManager.hasNotification(identifer: .buy) { (isPresent) in
            DispatchQueue.main.async {
                self.buyCell.switchView.isOn = isPresent ? true : false
            }
        }
        buyCell.accessoryView?.tag = 0
        
        sellCell = setupToggleCell(text: "Sell reminder")
        sellCell.selectionStyle = .none
        notificationsManager.hasNotification(identifer: .sell) { (isPresent) in
            DispatchQueue.main.async {
                self.sellCell.switchView.isOn = isPresent ? true : false
            }
        }
        sellCell.accessoryView?.tag = 1
        
        customBuyCell = setupCell(text: "Set buy reminder")
        customBuyCell.textLabel?.textColor = .grass1
        customBuyCell.detailTextLabel?.font = .preferredFont(forTextStyle: .caption1)
        
        
        customSellCell = setupCell(text: "Set sell reminder")
        customSellCell.detailTextLabel?.font = .preferredFont(forTextStyle: .caption1)
        customSellCell.textLabel?.textColor = .grass1
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check for permission
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                DispatchQueue.main.async {
                    let alert = AlertHelper.createDefaultAction(title: "Oh no ):", message: "NookNook can't send you reminders if you don't enable notifications. Please go to settings and enable it!")
                    self.present(alert, animated: true)
                }
                self.notificationsManager.checkStatus { (status) in
                    self.disableViews(status: status)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customBuyCell.detailTextLabel?.text = buyLabel
        customSellCell.detailTextLabel?.text = sellLabel
        
        if !UDHelper.getIsAdsPurchased() {
            self.view.addSubview(adBannerView)
            adBannerView.load(GADRequest())
        } else {
            adBannerView.removeFromSuperview()
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1 : return 1
        case 2: return 2
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return buyCell
        case 1: return sellCell
        case 2:
            switch indexPath.row {
            case 0: return customBuyCell
            case 1: return customSellCell
            default: fatalError("Invalid rows")
            }
            
        default: fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 180
        case 2: return 44 * 1.5
        default: return .nan
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = UIView()
            let imageView = UIImageView()
            let label = UILabel()
            
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .dirt1
            imageView.image = IconUtil.systemIcon(of: .reminder, weight: .regular).withRenderingMode(.alwaysTemplate)
            
            
            label.numberOfLines = 0
            label.text = "NookNook will remind you to buy turnip every \(buyLabel).\nAnd to sell turnip every \(sellLabel)."
            label.lineBreakMode = .byWordWrapping
            label.textColor = UIColor.dirt1.withAlphaComponent(0.5)
            label.font = .preferredFont(forTextStyle: .caption1)
            
            
            headerView.addSubview(imageView)
            headerView.addSubview(label)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                imageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
                imageView.heightAnchor.constraint(equalToConstant: 60),
                imageView.widthAnchor.constraint(equalToConstant: 60),
                
                label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 10),
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20 * 2),
                label.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.95)
            ])
            return headerView
        case 2:
            let headerView = UIView()
            let label = UILabel()
            
            label.numberOfLines = 0
            label.text = "Custom time"
            label.lineBreakMode = .byWordWrapping
            label.textColor = UIColor.dirt1.withAlphaComponent(0.5)
            label.font = .preferredFont(forTextStyle: .title3)
            
            
            headerView.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0),
                label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
                label.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.9)
            ])
            return headerView
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.detailTextLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0, 1: break
        case 2:
            switch indexPath.row {
            case 0:
                mcPicker = dayTimeHelper.createMcPicker(selections: UserPersistEngine.loadReminder(reminderType: .buy), reminderType: .buy)
                mcPicker.show(doneHandler: { [weak self] (selections: [Int : String]) -> Void in
                    DispatchQueue.main.async {
                        self!.buyLabel = self!.dayTimeHelper.renderTime(timeDict: selections)
                        self!.customBuyCell.detailTextLabel?.text = self!.dayTimeHelper.renderTime(timeDict: selections)
                        self?.tableView.reloadData()
                        UserPersistEngine.saveReminder(timeDict: selections, reminderType: .buy)
                        self!.buyCell.valueChanged(sender: self!.buyCell.switchView)
                        Taptic.successTaptic()
                    }
                })
                
            case 1:
                mcPicker = dayTimeHelper.createMcPicker(selections: UserPersistEngine.loadReminder(reminderType: .sell), reminderType: .sell)
                mcPicker.show(doneHandler: { [weak self] (selections: [Int : String]) -> Void in
                    DispatchQueue.main.async {
                        self!.sellLabel = self!.dayTimeHelper.renderTime(timeDict: selections)
                        self!.customSellCell.detailTextLabel?.text = self!.dayTimeHelper.renderTime(timeDict: selections)
                        self?.tableView.reloadData()
                        UserPersistEngine.saveReminder(timeDict: selections, reminderType: .sell)
                        self!.sellCell.valueChanged(sender: self!.sellCell.switchView)
                        Taptic.successTaptic()
                    }
                })
            default: break
            }
        default: break
        }
    }
    
    
    // MARK: - Setup views
    private func setBar() {
        self.configureNavigationBar(title: "Turnip reminder", preferredLargeTitle: false)
        self.view.backgroundColor = .cream1
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupToggleCell(text: String) -> TurnipTableViewCell {
        let cell = TurnipTableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.backgroundColor = .cream2
        cell.textLabel?.text = text
        cell.textLabel?.textColor = .dirt1
        
        return cell
    }
    
    private func setupCell(text: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.backgroundColor = .cream2
        cell.textLabel?.text = text
        cell.textLabel?.textColor = .dirt1
        
        return cell
    }
    
    // MARK: - Utilities functions
    private func disableViews(status: Bool) {
        DispatchQueue.main.async {
            self.buyCell.switchView.isEnabled = status ? true : false
            self.sellCell.switchView.isEnabled = status ? true : false
            self.buyCell.selectionStyle = .none
            self.sellCell.selectionStyle = .none
            self.buyCell.textLabel?.textColor = .lightGray
            self.sellCell.textLabel?.textColor = .lightGray
            self.customBuyCell.textLabel?.textColor = .lightGray
            self.customSellCell.textLabel?.textColor = .lightGray
            self.customBuyCell.selectionStyle = .none
            self.customSellCell.selectionStyle = .none
            self.customBuyCell.detailTextLabel?.textColor = .lightGray
            self.customSellCell.detailTextLabel?.textColor = .lightGray
        }
    }
    
}
