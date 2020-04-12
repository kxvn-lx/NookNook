//
//  ItemsTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 11/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class ItemsTableViewController: UITableViewController {
    
    let ITEM_CELL = "ItemCell"
    
    var favouritedItems: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        setBar()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ITEM_CELL, for: indexPath)
        
        if let itemCell = cell as? ItemTableViewCell {
            itemCell.itemImageView.sd_setImage(with: ImageEngine.parseURL(of: static_item.image!), placeholderImage: nil)
            itemCell.itemNameLabel.text = static_item.name
            itemCell.obtainedFromLabel.text = static_item.obtainedFrom
            itemCell.buyLabel.text = "Buy: \(static_item.buy!)"
            itemCell.sellLabel.text = "Sell: \(static_item.sell!)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // swipe right function
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let favouriteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if !self.favouritedItems.contains(static_item) {
                self.favouritedItems.append(static_item)
            } else {
                if let index = self.favouritedItems.firstIndex(of: static_item) {
                    self.favouritedItems.remove(at: index)
                }
            }
            
            success(true)
        })
        let starOption = favouritedItems.contains(static_item) ? "star.fill" : "star"
        let favConfig = UIImage.SymbolConfiguration(weight: .thin)
        let star = UIImage(systemName: starOption, withConfiguration: favConfig)
        favouriteAction.image = star
        favouriteAction.backgroundColor = UIColor(named: ColourUtil.primary2.rawValue)
        
        return UISwipeActionsConfiguration(actions: [favouriteAction])
        
    }
    
    // Change the colour of Tab bar and nav bar.
    private func setBar() {
        tabBarController?.tabBar.barTintColor = UIColor(named: ColourUtil.primary.rawValue)
        self.configureNavigationBar(largeTitleColor: .black, backgoundColor: UIColor(named: ColourUtil.primary.rawValue)!, tintColor: .black, title: "Items", preferredLargeTitle: true)
    }
    
}
