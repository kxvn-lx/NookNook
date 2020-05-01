//
//  TurnipReminderTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 30/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftEntryKit

class TurnipReminderTableViewController: UITableViewController {
    
    private var buyCell = TurnipTableViewCell()
    private var sellCell = TurnipTableViewCell()
    
    private var notificationsManager = NotificationEngine()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        
        
        let text = "Buy reminder will be always on sunday morning (06:00 AM).\nwhile Sell reminder will be always on friday night. (06:00 PM).\n\nThis is because the app will make sure you buy it before turnip seller leave, and make sure that you sell your turnip before it's too late!"
        self.setCustomFooterView(text: text, height: 100)
    }
    
    override func loadView() {
        super.loadView()
        
        buyCell = setupCell(text: "Buy reminder")
        notificationsManager.hasNotification(identifer: .buy) { (isPresent) in
            DispatchQueue.main.async {
                self.buyCell.switchView.isOn = isPresent ? true : false
            }
        }
        buyCell.accessoryView?.tag = 0
        
        sellCell = setupCell(text: "Sell reminder")
        notificationsManager.hasNotification(identifer: .sell) { (isPresent) in
            DispatchQueue.main.async {
                self.sellCell.switchView.isOn = isPresent ? true : false
            }
        }
        sellCell.accessoryView?.tag = 1
        
        // check for permission
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                DispatchQueue.main.async {
                    let ( view, attributes ) = ModalFactory.showPopupMessage(title: "Oh no!", description: "NookNook can't send you reminders if you don't enable notifications. Please go to settings and enable it!", image: UIImage(named: "sad"))
                    SwiftEntryKit.display(entry: view, using: attributes)
                }
                self.notificationsManager.checkStatus { (status) in
                    DispatchQueue.main.async {
                        self.buyCell.switchView.isEnabled = status ? true : false
                        self.sellCell.switchView.isEnabled = status ? true : false
                        self.buyCell.selectionStyle = .none
                        self.sellCell.selectionStyle = .none
                        self.buyCell.textLabel?.textColor = .lightGray
                        self.sellCell.textLabel?.textColor = .lightGray
                    }
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return buyCell
        case 1: return sellCell
        default: fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    // MARK: - Setup views
    private func setBar() {
        self.configureNavigationBar(title: "Turnip reminder", preferredLargeTitle: false)
        self.view.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupCell(text: String) -> TurnipTableViewCell {
        let cell = TurnipTableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        cell.textLabel?.text = text
        cell.textLabel?.textColor =  UIColor(named: ColourUtil.dirt1.rawValue)
        
        return cell
    }
    
    
    
    
}
