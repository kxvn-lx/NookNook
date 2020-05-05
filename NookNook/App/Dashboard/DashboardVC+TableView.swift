//
//  DashboardVC+TableView.swift
//  NookNook
//
//  Created by Kevin Laminto on 29/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

// MARK:- UITableView data source
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                // favourite cell
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: FAVOURITE_CELL)
                cell.textLabel!.text = "Favourites"
                cell.imageView?.image = IconUtil.systemIcon(of: .starFill, weight: .regular).withRenderingMode(.alwaysTemplate)
                cell.accessoryType = .disclosureIndicator
                return cell
                
            case 1:
                // turnip cell
                let cell = UITableViewCell(style: .default, reuseIdentifier: FAVOURITE_CELL)
                cell.textLabel!.text = "Turnip reminder"
                cell.imageView?.image = IconUtil.systemIcon(of: .reminder, weight: .regular).withRenderingMode(.alwaysTemplate)
                cell.accessoryType = .disclosureIndicator
                return cell
            default: break
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: CRITTER_CELL)
                cell.textLabel!.text = "Critters this month"
                cell.detailTextLabel?.text = "Bugs: \(caughtBugsMonth.count)/\(monthlyBug.count) | Fishes: \(caughtFishesMonth.count)/\(monthlyFish.count)"
                cell.accessoryType = .disclosureIndicator
                return cell
            // Total bugs count
            case 1:
                let totalBugsCount = DataEngine.loadCritterJSON(from: .bugsMain).count
                let caughtBugsCount = self.favouritesManager.caughtCritters.filter( {$0.category == Categories.bugs.rawValue} ).count
                let formatted = String(format: "%.1f", (Float(caughtBugsCount) / Float(totalBugsCount)) * 100)
                
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CRITTER_CELL)
                cell.selectionStyle = .none
                cell.textLabel!.text = "Total bugs caught (\(formatted)%)"
                cell.detailTextLabel?.text = "\(caughtBugsCount)/\(totalBugsCount)"
                return cell
                
            // Total fishes count
            case 2:
                let totalFishesCount = DataEngine.loadCritterJSON(from: .fishesMain).count
                let caughtFishesCount = self.favouritesManager.caughtCritters.filter( {$0.category == Categories.fishes.rawValue} ).count
                let formatted = String(format: "%.1f", (Float(caughtFishesCount) / Float(totalFishesCount)) * 100)
                
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CRITTER_CELL)
                cell.selectionStyle = .none
                cell.textLabel!.text = "Total bugs caught (\(formatted)%)"
                cell.detailTextLabel?.text = "\(caughtFishesCount)/\(totalFishesCount)"
                return cell
            default: break
            }
        default: fatalError("Indexpath out of range.")
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default: fatalError("Invalid rows detected.")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return ""
        case 1: return "Critters Information"
        default: return " "
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .cream1
        cell.tintColor =  .dirt1
        cell.textLabel?.textColor = .dirt1
        cell.detailTextLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
                // Favourites
            case 0:
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesTableViewController
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated:true, completion: nil)
                // Turnip Reminder
            case 1:
                let vc = self.storyboard!.instantiateViewController(withIdentifier: TURNIP_ID) as! TurnipReminderTableViewController
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated:true, completion: nil)
            default: break
            }
            
        case 1:
            switch indexPath.row {
                // Critters Monthly
            case 0:
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "CrittersMonthlyVC") as! CrittersMonthlyTableViewController
                vc.profileDelegate = self
                
                let navController = UINavigationController(rootViewController: vc)
                navController.presentationController?.delegate = self
                self.present(navController, animated:true, completion: nil)
            case 1: break
            case 2: break
            default: break
            }
        default: fatalError("Invalid section detected")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        header.textLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        header.textLabel?.text? = header.textLabel?.text?.capitalized ?? ""
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
}
