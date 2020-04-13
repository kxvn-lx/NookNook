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
    var filteredItems: [Item] = []
    var currentCategory: Categories = Categories.housewares
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        setBar()
        
        // Default categories to be presented
        items = DataEngine.loadJSON(category: currentCategory)
        
          
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search \(items.count) items..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
          return filteredItems.count
        }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ITEM_CELL, for: indexPath)
        
        if let itemCell = cell as? ItemTableViewCell {
            itemCell.itemImageView.sd_imageTransition = .fade
            itemCell.itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            let item: Item
            if isFiltering {
                item = filteredItems[indexPath.row]
            } else {
                item = items[indexPath.row]
            }
            
            itemCell.itemImageView.sd_setImage(with: ImageEngine.parseURL(of: item.image!), placeholderImage: nil)
            itemCell.itemNameLabel.text = item.name
            itemCell.obtainedFromLabel.text = items[indexPath.row].obtainedFrom
            itemCell.buyLabel.attributedText = PriceEngine.renderPrice(amount: item.buy, with: .buy)
            itemCell.sellLabel.attributedText = PriceEngine.renderPrice(amount: item.sell, with: .sell)
            
            itemCell.isFavImageView.image = favouritedItems.contains(item) ?  IconUtil.systemIcon(of: IconUtil.IconName.starFill, weight: .thin) : nil
            itemCell.customisableImageView.image = item.isCustomisable! ? IconUtil.systemIcon(of: IconUtil.IconName.paintbrush, weight: .thin) : nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem: Item
        if isFiltering {
            selectedItem = filteredItems[indexPath.row]
        } else {
            selectedItem = items[indexPath.row]
        }
        
        print(selectedItem.name)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
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
        favouriteAction.backgroundColor = UIColor(named: ColourUtil.grass2.rawValue)
        
        return UISwipeActionsConfiguration(actions: [favouriteAction])
        
    }
    
    // Modify the UI
    private func setBar() {
        tabBarController?.tabBar.barTintColor = UIColor(named: ColourUtil.grass1.rawValue)
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Items", preferredLargeTitle: true)
        
        self.tableView.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
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
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: CAT_ID) as! CategoriesTableViewController
        vc.filteredCategories = Categories.items()
        vc.catDelegate = self
        vc.currentCategory = currentCategory
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    
}

extension ItemsTableViewController: CatDelegate {
    func parseNewCategory(of category: Categories) {
        currentCategory = category
        items = DataEngine.loadJSON(category: currentCategory)
        tableView.reloadData()
        searchController.searchBar.placeholder = "Search \(items.count) items..."
    }
}

extension ItemsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
      filteredItems = items.filter { (item: Item) -> Bool in
        return item.name.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }
}
