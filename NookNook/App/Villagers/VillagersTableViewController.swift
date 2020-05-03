//
//  VillagersTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 17/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftEntryKit

class VillagersTableViewController: UITableViewController {
    
    // Constants
    private let VILLAGER_CELL = "VillagerCell"
    private let DETAIL_ID = "Detail"
    
    // Instance
    private var favouritesManager: DataPersistEngine!
    private var sortType: SortEngine.Sort!
    
    // General variables
    var villagers: [Villager] = []
    var filteredVillagers: [Villager] = []
    var currentCategory: Categories = Categories.villagers
    
    // Search properties
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    // MARK: - Tableview init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        // Default categories to be presented
        villagers = DataEngine.loadVillagersJSON(from: currentCategory).sorted(by: { $0.name < $1.name } )
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search \(villagers.count) villagers..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritesManager = DataPersistEngine()
        self.navigationController?.navigationBar.sizeToFit()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        setupSearchBar(searchBar: searchController.searchBar)
    }
    
    private func setupSearchBar(searchBar : UISearchBar) {
        searchBar.setPlaceholderTextColorTo(color: UIColor.lightGray)
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            if filteredVillagers.count == 0 {
                self.tableView.setEmptyMessage("No villager(s) found 😢.\nPerhaps you made a mistake?")
            }
            else {
                self.tableView.restore()
            }
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
            
            villagerCell.imgView.sd_setImage(with: ImageEngine.parseAcnhURL(with: villager.image, of: villager.category, mediaType: .icons), placeholderImage: UIImage(named: "placeholder"))
            villagerCell.nameLabel.text = villager.name
            villagerCell.speciesLabel.text = villager.species
            villagerCell.personalityLabel.setTitle(villager.personality, for: .normal)
            villagerCell.personalityLabel.sizeToFit()
            villagerCell.bdayLabel.text = villager.bdayString
            villagerCell.genderLabel.text = villager.gender
            
            villagerCell.isFavImageView.image = self.favouritesManager.favouritedVillagers.contains(villager) ?  IconUtil.systemIcon(of: IconUtil.IconName.starFill, weight: .thin) : nil
            
            let isResident = self.favouritesManager.residentVillagers.contains(villager) ? "R" : ""
            villagerCell.isResidentLabel.text = isResident
            
            villagerCell.isResidentLabel.isHidden =  self.favouritesManager.residentVillagers.contains(villager) ? false : true
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
        cell.backgroundColor = .cream1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(currentCategory.rawValue.capitalizingFirstLetter())\(self.sortType == nil ? ": by name" : ": by \(self.sortType.rawValue)")"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .cream1
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = .dirt1
    }
    
    // swipe right function
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let villager: Villager
        if self.isFiltering {
            villager = self.filteredVillagers[indexPath.row]
        } else {
            villager = self.villagers[indexPath.row]
        }
        
        let favouriteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            self.favouritesManager.saveFavouritedVillager(villager: villager)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .left)
            }
            Taptic.lightTaptic()
            success(true)
        })
        
        favouriteAction.image = self.favouritesManager.favouritedVillagers.contains(villager) ? IconUtil.systemIcon(of: .starFill, weight: .thin) : IconUtil.systemIcon(of: .star, weight: .thin)
        
        let residentAction = UIContextualAction(style: .normal, title:  "Resident", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let villager: Villager
            if self.isFiltering {
                villager = self.filteredVillagers[indexPath.row]
            } else {
                villager = self.villagers[indexPath.row]
            }
            
            if self.favouritesManager.residentVillagers.count <= 9 {
                self.favouritesManager.saveResidentVillager(villager: villager)
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .left)
                }
                Taptic.lightTaptic()
                success(true)
            }
            else if self.favouritesManager.residentVillagers.count <= 10 && self.favouritesManager.residentVillagers.contains(villager) {
                self.favouritesManager.saveResidentVillager(villager: villager)
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .left)
                }
                Taptic.lightTaptic()
                success(true)
            }
            else {
                let ( view, attributes ) = ModalHelper.showPopupMessage(title: "Woah there!", description: "It appears that you have the max number of resident.", image: UIImage(named: "sad"))
                
                SwiftEntryKit.display(entry: view, using: attributes)
                
                Taptic.errorTaptic()
                success(false)
            }
        })
        favouriteAction.backgroundColor = .grass1
        residentAction.backgroundColor = .gold1
        
        return UISwipeActionsConfiguration(actions: [favouriteAction, residentAction])
        
    }
    
    
    // MARK: - Modify UI
    private func setBar() {
        tabBarController?.tabBar.barTintColor = .grass1
        self.configureNavigationBar(title: "Villagers")
        self.tableView.backgroundColor = .cream1
        
        tabBarController?.tabBar.tintColor = .white
        
        // add Left bar button item
        let button: UIButton = UIButton(type: .custom)
        button.setImage(IconUtil.systemIcon(of: .sort, weight: .regular), for: .normal)
        button.addTarget(self, action: #selector(sortButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dirt1]
    }
    
    @objc private func sortButtonPressed() {
        let alert = UIAlertController(title: "Sort villagers", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Name", style: .default , handler:{ (UIAlertAction) in
            self.villagers = SortEngine.sortVillagers(villagers: self.villagers, with: .name)
            self.sortType = .name
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            Taptic.lightTaptic()
            
        }))
        alert.addAction(UIAlertAction(title: "Species", style: .default , handler:{ (UIAlertAction) in
            self.villagers = SortEngine.sortVillagers(villagers: self.villagers, with: .species)
            self.sortType = .species
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            Taptic.lightTaptic()
        }))
        alert.addAction(UIAlertAction(title: "Personality", style: .default , handler:{ (UIAlertAction) in
            self.villagers = SortEngine.sortVillagers(villagers: self.villagers, with: .personality)
            self.sortType = .personality
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            Taptic.lightTaptic()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Searc Results Delegate
extension VillagersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredVillagers = villagers.filter { (item: Villager) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Tabbarcontroller delegate
extension VillagersTableViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 3 {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}
