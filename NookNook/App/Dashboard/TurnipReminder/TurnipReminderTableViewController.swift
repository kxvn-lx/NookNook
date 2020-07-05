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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        self.addHeaderImage(withIcon: IconHelper.systemIcon(of: .reminder, weight: .regular), height: 100)
        
        buyLabel = dayTimeHelper.renderTime(timeDict: UserPersistEngine.loadReminder(reminderType: .buy))
        sellLabel = dayTimeHelper.renderTime(timeDict: UserPersistEngine.loadReminder(reminderType: .sell))
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
        notificationCenter.requestAuthorization(options: options) { (didAllow, _) in
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
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 2
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0 : return buyCell
            case 1: return sellCell
            default: fatalError("Invalid rows")
            }
        case 1:
            switch indexPath.row {
            case 0: return customBuyCell
            case 1: return customSellCell
            default: fatalError("Invalid rows")
            }
        default: fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.detailTextLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0: break
        case 1:
            switch indexPath.row {
            case 0:
                mcPicker = dayTimeHelper.createMcPicker(selections: UserPersistEngine.loadReminder(reminderType: .buy), reminderType: .buy)
                mcPicker.show(doneHandler: { [weak self] (selections: [Int: String]) -> Void in
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
                mcPicker.show(doneHandler: { [weak self] (selections: [Int: String]) -> Void in
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "NookNook will remind you to buy turnip every \(buyLabel). And to sell turnip every \(sellLabel)"
        case 1: return "Custom time"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 44 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        switch section {
        case 0: headerView.textLabel!.text = "NookNook will remind you to buy turnip every \(buyLabel). And to sell turnip every \(sellLabel)"
        case 1:
            headerView.textLabel!.font = .preferredFont(forTextStyle: .title3)
            headerView.textLabel!.text = "Custom time"
        default: headerView.textLabel!.text = ""
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
            self.buyCell.switchView.isEnabled = status
            self.sellCell.switchView.isEnabled = status
            
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
            
            self.customBuyCell.isUserInteractionEnabled = status
            self.customSellCell.isUserInteractionEnabled = status
        }

    }
    
}
