//
//  ItemsTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 11/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class ItemsTableViewController: UITableViewController {
    
    let ITEM_CELL = "ItemCell"
    
    var favouritedItems: [Item] = []
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        setBar()
        items = DataEngine.loadJSON(category: DataEngine.Categories.housewares)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ITEM_CELL, for: indexPath)
        
        if let itemCell = cell as? ItemTableViewCell {
            itemCell.itemImageView.sd_setImage(with: ImageEngine.parseURL(of: items[indexPath.row].image!), placeholderImage: nil)
            itemCell.itemNameLabel.text = items[indexPath.row].name
            itemCell.obtainedFromLabel.text = items[indexPath.row].obtainedFrom
            itemCell.buyLabel.attributedText = PriceEngine.renderPrice(amount: items[indexPath.row].buy, with: .buy)
            itemCell.sellLabel.attributedText = PriceEngine.renderPrice(amount: items[indexPath.row].sell, with: .sell)
            
            itemCell.isFavImageView.image = favouritedItems.contains(items[indexPath.row]) ?  IconUtil.systemIcon(of: IconUtil.IconName.starFill, weight: .thin) : nil
            itemCell.customisableImageView.image = items[indexPath.row].isCustomisable! ? IconUtil.systemIcon(of: IconUtil.IconName.paintbrush, weight: .thin) : nil
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
            if !self.favouritedItems.contains(self.items[indexPath.row]) {
                self.favouritedItems.append(self.items[indexPath.row])
            } else {
                if let index = self.favouritedItems.firstIndex(of: self.items[indexPath.row]) {
                    self.favouritedItems.remove(at: index)
                }
            }
            
            self.tableView.reloadRows(at: [indexPath], with: .left)
            
            success(true)
        })
        let starOption = favouritedItems.contains(self.items[indexPath.row]) ? IconUtil.IconName.starFill : IconUtil.IconName.star
        favouriteAction.image = IconUtil.systemIcon(of: starOption, weight: .thin)
        favouriteAction.backgroundColor = UIColor(named: ColourUtil.primary2.rawValue)
        
        return UISwipeActionsConfiguration(actions: [favouriteAction])
        
    }
    
    // Modify the UI
    private func setBar() {
        tabBarController?.tabBar.barTintColor = UIColor(named: ColourUtil.primary.rawValue)
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.primary.rawValue)!, tintColor: .white, title: "Items", preferredLargeTitle: true)
        
        tabBarController?.tabBar.items![0].image = UIImage(systemName: "house")
        tabBarController?.tabBar.items![0].selectedImage = UIImage(systemName: "house.fill")
        tabBarController?.tabBar.tintColor = .white
        
        let button: UIButton = UIButton(type: .custom)
        button.setImage(IconUtil.systemIcon(of: .filter, weight: .regular), for: .normal)
        button.addTarget(self, action: #selector(filterButtonPressed), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)

        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    
    @objc func filterButtonPressed() {
        let CAT_ID = "Categories"
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: CAT_ID)
        self.present(vc, animated: true, completion: nil)
    }
    
}
