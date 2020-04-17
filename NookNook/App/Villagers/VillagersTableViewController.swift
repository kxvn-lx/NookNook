//
//  VillagersTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 17/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class VillagersTableViewController: UITableViewController {

    private let VILLAGER_CELL = "VillagerCell"
    private let DETAIL_ID = "Detail"
    
    var favouriteVillagers: [Villager] = []
    var villagers: [Villager] = []
    var filteredVillagers: [Villager] = []
    var currentCategory: Categories = Categories.villagers
    
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
        tableView.estimatedRowHeight = 100
        
        // Default categories to be presented
        villagers = DataEngine.loadVillagersJSON(from: currentCategory)
        
          
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search \(villagers.count) villagers..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        setBar()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredVillagers.count
        }
        return villagers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VILLAGER_CELL, for: indexPath)

        if let villagerCell = cell as? VillagerTableViewCell {
            villagerCell.imgView.sd_imageTransition = .fade
            villagerCell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray

            let villager: Villager
            if isFiltering {
                villager = filteredVillagers[indexPath.row]
            } else {
                villager = villagers[indexPath.row]
            }

            villagerCell.imgView.sd_setImage(with: ImageEngine.parseVillagerURL(with: villager.image, of: 0), placeholderImage: nil)
            villagerCell.nameLabel.text = villager.name
            villagerCell.speciesLabel.text = villager.species
            villagerCell.personalityLabel.setTitle(villager.personality, for: .normal)
            villagerCell.personalityLabel.sizeToFit()
            villagerCell.bdayLabel.text = villager.bdayString
            villagerCell.genderLabel.text = villager.gender

            villagerCell.isFavImageView.image = favouriteVillagers.contains(villager) ?  IconUtil.systemIcon(of: IconUtil.IconName.starFill, weight: .thin) : nil
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedVillager: Villager
        if isFiltering {
            selectedVillager = filteredVillagers[indexPath.row]
        } else {
            selectedVillager = villagers[indexPath.row]
        }
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: DETAIL_ID) as! DetailViewController

        vc.parseOject(from: .villagers, object: selectedVillager)

        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(currentCategory.rawValue)"
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
            if !self.favouriteVillagers.contains(self.villagers[indexPath.row]) {
                self.favouriteVillagers.append(self.villagers[indexPath.row])
            } else {
                if let index = self.favouriteVillagers.firstIndex(of: self.villagers[indexPath.row]) {
                    self.favouriteVillagers.remove(at: index)
                }
            }
            
            self.tableView.reloadRows(at: [indexPath], with: .left)
            
            success(true)
        })
        let starOption = favouriteVillagers.contains(self.villagers[indexPath.row]) ? IconUtil.IconName.starFill : IconUtil.IconName.star
        favouriteAction.image = IconUtil.systemIcon(of: starOption, weight: .thin)
        favouriteAction.backgroundColor = UIColor(named: ColourUtil.grass2.rawValue)
        
        return UISwipeActionsConfiguration(actions: [favouriteAction])
        
    }
    

    // Modify the UI
    private func setBar() {
        tabBarController?.tabBar.barTintColor = UIColor(named: ColourUtil.grass1.rawValue)
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Villagers", preferredLargeTitle: true)
        
        self.tableView.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
        tabBarController?.tabBar.tintColor = .white
    }
}

extension VillagersTableViewController: CatDelegate {
    func parseNewCategory(of category: Categories) {
        currentCategory = category
        villagers = DataEngine.loadVillagersJSON(from: currentCategory)
        tableView.reloadData()
        searchController.searchBar.placeholder = "Search \(villagers.count) villagers..."
    }
}

extension VillagersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
      filteredVillagers = villagers.filter { (item: Villager) -> Bool in
        return item.name.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }
}

