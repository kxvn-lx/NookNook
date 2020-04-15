//
//  CrittersTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 14/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class CrittersTableViewController: UITableViewController {
    
    let CRITTER_CELL = "CritterCell"
    private let DETAIL_ID = "Detail"
    
    var favouritedCritters: [Critter] = []
    var critters: [Critter] = []
    var filteredCritters: [Critter] = []
    var currentCategory: Categories = Categories.worldBugs
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        setBar()
        
        // Default categories to be presented
        critters = DataEngine.loadCritterJSON(from: currentCategory)
        
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search \(critters.count) items..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCritters.count
        }
        return critters.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CRITTER_CELL, for: indexPath)
        
        if let critterCell = cell as? CritterTableViewCell {
            critterCell.imgView.sd_imageTransition = .fade
            critterCell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            let critter: Critter
            if isFiltering {
                critter = filteredCritters[indexPath.row]
            } else {
                critter = critters[indexPath.row]
            }
            
            critterCell.imgView.sd_setImage(with: ImageEngine.parseURL(of: critter.image!), placeholderImage: nil)
            critterCell.nameLabel.text = critter.name
            critterCell.obtainedFromLabel.text = critter.obtainedFrom.isEmpty ? "Location unknown" : critter.obtainedFrom
            critterCell.timeLabel.text = TimeEngine.renderTime(of: critter.startTime, and: critter.endTime)
            critterCell.sellLabel.attributedText = PriceEngine.renderPrice(amount: critter.sell, with: .sell, of: 12)
            critterCell.weatherLabel.text = critter.weather
            
            critterCell.isFavImageView.image = favouritedCritters.contains(critter) ?  IconUtil.systemIcon(of: IconUtil.IconName.starFill, weight: .thin) : nil
            critterCell.rarityLabel.setTitle(critter.rarity, for: .normal)
            
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCritter: Critter
        if isFiltering {
            selectedCritter = filteredCritters[indexPath.row]
        } else {
            selectedCritter = critters[indexPath.row]
        }
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: DETAIL_ID) as! DetailViewController
        
        vc.parseOject(from: .critters, object: selectedCritter)
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch currentCategory {
        case .worldBugs:
            return "Bugs"
        case .worldFishes:
            return "Fishes"
        default:
            return "No Category found!"
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
    }
    
    // swipe right function
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let favouriteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if !self.favouritedCritters.contains(self.critters[indexPath.row]) {
                self.favouritedCritters.append(self.critters[indexPath.row])
            } else {
                if let index = self.favouritedCritters.firstIndex(of: self.critters[indexPath.row]) {
                    self.favouritedCritters.remove(at: index)
                }
            }
            
            self.tableView.reloadRows(at: [indexPath], with: .left)
            
            success(true)
        })
        let starOption = favouritedCritters.contains(self.critters[indexPath.row]) ? IconUtil.IconName.starFill : IconUtil.IconName.star
        favouriteAction.image = IconUtil.systemIcon(of: starOption, weight: .thin)
        favouriteAction.backgroundColor = UIColor(named: ColourUtil.grass2.rawValue)
        
        return UISwipeActionsConfiguration(actions: [favouriteAction])
        
    }
    
    
    // Modify the UI
    private func setBar() {
        tabBarController?.tabBar.barTintColor = UIColor(named: ColourUtil.grass1.rawValue)
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Critters", preferredLargeTitle: true)
        
        self.tableView.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
        let button: UIButton = UIButton(type: .custom)
        button.setImage(IconUtil.systemIcon(of: .filter, weight: .regular), for: .normal)
        button.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func filterButtonPressed() {
        let CAT_ID = "Categories"
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: CAT_ID) as! CategoriesTableViewController
        vc.filteredCategories = Categories.critters()
        vc.catDelegate = self
        vc.currentCategory = currentCategory
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    
}

extension CrittersTableViewController: CatDelegate {
    func parseNewCategory(of category: Categories) {
        currentCategory = category
        critters = DataEngine.loadCritterJSON(from: currentCategory)
        tableView.reloadData()
        searchController.searchBar.placeholder = "Search \(critters.count) items..."
    }
}

extension CrittersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCritters = critters.filter { (critter: Critter) -> Bool in
            return critter.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}
