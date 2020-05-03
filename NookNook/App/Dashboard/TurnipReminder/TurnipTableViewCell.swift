 //
 //  TurnipTableViewCell.swift
 //  NookNook
 //
 //  Created by Kevin Laminto on 30/4/20.
 //  Copyright © 2020 Kevin Laminto. All rights reserved.
 //
 
 import UIKit
 import UserNotifications
 
 class TurnipTableViewCell: UITableViewCell {
    
    let switchView = UISwitch(frame: .zero)
    
    private var notificationsManager = NotificationEngine()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        switch sender.tag {
        case 0:
            let identifier = NotificationEngine.Identifier.buy
            // Buy reminder
            if sender.isOn {
                let timeDict = UserPersistEngine.loadReminder(reminderType: .buy).sorted(by: { $0 < $1 })
                let weekday = ReminderHelper.days.firstIndex(of: timeDict[0].value)! + 1
                var hour = timeDict[3].value == "AM" ? Int(timeDict[1].value)! : Int(timeDict[1].value)! + 12
                let min = Int(timeDict[2].value)!
                if Int(timeDict[1].value)! == 12 {
                    hour = timeDict[3].value == "AM" ? 0 : 12
                }
                
                dateComponents.weekday = weekday
                dateComponents.hour = hour
                dateComponents.minute = min
                
                notificationsManager.createNotification(title: "Buy turnip reminder", body: "Don't forget to buy your turnip today! Turnip seller will leave your island around noon.", dateComponents: dateComponents, identifier: identifier)
            }
            else {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier.rawValue])
            }
            
        case 1:
            let identifier = NotificationEngine.Identifier.sell
            // Sell reminder
            if sender.isOn {
                let timeDict = UserPersistEngine.loadReminder(reminderType: .sell).sorted(by: { $0 < $1 })
                let weekday = ReminderHelper.days.firstIndex(of: timeDict[0].value)! + 1
                var hour = timeDict[3].value == "AM" ? Int(timeDict[1].value)! : Int(timeDict[1].value)! + 12
                let min = Int(timeDict[2].value)!
                if Int(timeDict[1].value)! == 12 {
                    hour = timeDict[3].value == "AM" ? 0 : 12
                }
                
                
                dateComponents.weekday = weekday
                dateComponents.hour = hour
                dateComponents.minute = min
                notificationsManager.createNotification(title: "Sell turnip reminder", body: "Make sure you have sold your turnip this week! turnip will reset by sunday!", dateComponents: dateComponents, identifier: identifier)
            }
            else {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier.rawValue])
            }
            
        default: break
        }
    }
 }
