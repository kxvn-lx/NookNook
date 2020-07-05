//
//  FavouritesTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 20/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class FavouritesTableViewController: UITableViewController {
    
    private let FAVOURITE_CELL = "FavouriteCell"
    private let DETAIL_ID = "Detail"
    
    private var favouritesManager = DataPersistEngine()
    
    private var currentGroup = GroupType.items
    
    private var sc: UISegmentedControl!
    private var scView: UIView!
    
    private let items: [String] = [GroupType.items.rawValue.capitalizingFirstLetter(),
                                   GroupType.wardrobes.rawValue.capitalizingFirstLetter(),
                                   GroupType.villagers.rawValue.capitalizingFirstLetter()
    ]
    
    let search = UISearchController(searchResultsController: nil)
    
    enum GroupType: String {
        case items, wardrobes, villagers
    }
    
    private var favItems: [Item] = []
    private var favWardrobes: [Wardrobe] = []
    private var favVillagers: [Villager] = []
    
    private var filteredItems: [Item] = []
    private var filteredWardrobes: [Wardrobe] = []
    private var filteredVillagers: [Villager] = []
    
    var isSearchBarEmpty: Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return search.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        setBar()
        scView = SCHelper.createSC(items: items)
        sc = scView.viewWithTag(1) as? UISegmentedControl
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(changeSource), for: .valueChanged)
        
        favItems = favouritesManager.items
        favVillagers = favouritesManager.favouritedVillagers
        favWardrobes = favouritesManager.wardrobes
        
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search favourites..."
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.searchController = search
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentGroup {
        case .items:
            if isFiltering {
                return filteredItems.count
            } else {
                if favItems.isEmpty {
                    self.tableView.setEmptyMessage("Swipe right and press ⭑ to\nadd an item to your collection!")
                } else {
                    self.tableView.restore()
                }
            }
            return favouritesManager.items.count
        case .wardrobes:
            if isFiltering {
                return filteredWardrobes.count
            } else {
                if favWardrobes.isEmpty {
                    self.tableView.setEmptyMessage("Swipe right and press ⭑ to\nadd a clothings to your collection!")
                } else {
                    self.tableView.restore()
                }
            }
            return favouritesManager.wardrobes.count
        case .villagers:
            if isFiltering {
                return filteredVillagers.count
            } else {
                if favVillagers.isEmpty {
                    self.tableView.setEmptyMessage("Swipe right and press ⭑ to\nadd a villager to your collection!")
                } else {
                    self.tableView.restore()
                }
            }
            return favouritesManager.favouritedVillagers.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FAVOURITE_CELL, for: indexPath)
        switch currentGroup {
        case .items:
            sc.selectedSegmentIndex = 0
            
            let item: Item
            if isFiltering {
                item = filteredItems[indexPath.row]
            } else {
                item = favItems[indexPath.row]
            }
            
            if let cell = cell as? FavouriteTableViewCell {
                cell.imgView.sd_imageTransition = .fade
                cell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                
                cell.imgView.sd_setImage(with: ImageEngine.parseNPURL(with: item.image!, category: item.category), placeholderImage: nil)
                cell.nameLabel.text = item.name
                cell.label1.text = item.obtainedFrom
                cell.label3.attributedText = PriceEngine.renderPrice(amount: item.buy, with: .buy, of: 12)
                cell.label4.attributedText = PriceEngine.renderPrice(amount: item.sell, with: .sell, of: 12)
                
                cell.iconLabel1.isHidden = true
                cell.iconLabel2.isHidden = true
                cell.tagLabel.isHidden = true
                cell.label3.font = UIFont.systemFont(ofSize: cell.label3.font!.pointSize, weight: .regular)
            }
            
        case .villagers:
            let villager: Villager
            if isFiltering {
                villager = filteredVillagers[indexPath.row]
            } else {
                villager = favVillagers[indexPath.row]
            }
            
            sc.selectedSegmentIndex = 2
            if let cell = cell as? FavouriteTableViewCell {
                cell.imgView.sd_imageTransition = .fade
                cell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                
                // Fallback on older version
                var iconString = self.favouritesManager.favouritedVillagers[indexPath.row].image
                if !iconString.contains("https://acnhapi.com/v1/images/") {
                    iconString = "https://acnhapi.com/v1/icons/villagers/\(iconString)"
                } else {
                    iconString = self.favouritesManager.favouritedVillagers[indexPath.row].icon!
                }
                
                cell.imgView.sd_setImage(with: ImageEngine.parseAcnhURL(with: iconString), placeholderImage: nil)
                cell.nameLabel.text = villager.name
                cell.label1.text = villager.species
                cell.tagLabel.setTitle(villager.personality, for: .normal)
                cell.label3.text = villager.bdayString
                cell.label4.text = villager.gender
                cell.iconLabel1.text = self.favouritesManager.residentVillagers.contains(villager) ? "R" : ""
                
                cell.tagLabel.isHidden = false
                cell.label3.font = UIFont.systemFont(ofSize: cell.label3.font!.pointSize, weight: .semibold)
                cell.iconLabel2.isHidden = true
                cell.iconLabel1.isHidden = self.favouritesManager.residentVillagers.contains(villager) ? false : true
            }
            
        case.wardrobes:
            let wardrobe: Wardrobe
            if isFiltering {
                wardrobe = filteredWardrobes[indexPath.row]
            } else {
                wardrobe = favWardrobes[indexPath.row]
            }
            sc.selectedSegmentIndex = 1
            if let cell = cell as? FavouriteTableViewCell {
                cell.imgView.sd_imageTransition = .fade
                cell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                
                cell.imgView.sd_setImage(with: ImageEngine.parseNPURL(with: wardrobe.image!, category: wardrobe.category), placeholderImage: nil)
                cell.nameLabel.text = wardrobe.name
                cell.label1.text = wardrobe.obtainedFrom
                cell.label3.attributedText = PriceEngine.renderPrice(amount: wardrobe.buy, with: .buy, of: 12)
                cell.label4.attributedText = PriceEngine.renderPrice(amount: wardrobe.sell, with: .sell, of: 12)
                
                cell.iconLabel1.isHidden = true
                cell.iconLabel2.isHidden = true
                cell.tagLabel.isHidden = true
                cell.label3.font = UIFont.systemFont(ofSize: cell.label3.font!.pointSize, weight: .regular)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .cream1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: DETAIL_ID) as! DetailViewController
        
        switch currentGroup {
        case .items:
            vc.parseOject(from: .items, object: favItems[indexPath.row])
        case .wardrobes:
            vc.parseOject(from: .wardrobes, object: favWardrobes[indexPath.row])
        case .villagers:
            vc.parseOject(from: .villagers, object: favVillagers[indexPath.row])
        }
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return scView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch currentGroup {
            case .items:
                self.favouritesManager.saveItem(item: favItems[indexPath.row])
                self.favItems.remove(at: indexPath.row)
            case .villagers:
                self.favouritesManager.saveFavouritedVillager(villager: favVillagers[indexPath
                    .row])
                self.favVillagers.remove(at: indexPath.row)
            case .wardrobes:
                self.favouritesManager.saveWardrobe(wardrobe: favWardrobes[indexPath.row])
                self.favWardrobes.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    @objc func changeSource(sender: UISegmentedControl) {
        Taptic.lightTaptic()
        switch sender.selectedSegmentIndex {
        case 0:
            self.currentGroup = .items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case 1:
            self.currentGroup = .wardrobes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case 2:
            self.currentGroup = .villagers
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        default:
            fatalError("Invalid Segmented Control index.")
        }
    }
    
    private func setBar() {
        self.configureNavigationBar(title: "Favourites", preferredLargeTitle: false)
        self.view.backgroundColor = .cream1
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dirt1]
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        switch currentGroup {
        case .items:
            filteredItems = favItems.filter { (item: Item) -> Bool in
                return item.name.lowercased().contains(searchText.lowercased())
            }
            
        case .wardrobes:
            filteredWardrobes = favWardrobes.filter { (wardrobe: Wardrobe) -> Bool in
                return wardrobe.name.lowercased().contains(searchText.lowercased())
            }
            
        case .villagers:
            filteredVillagers = favVillagers.filter { (villager: Villager) -> Bool in
                return villager.name.lowercased().contains(searchText.lowercased())
            }
            
        }
        
        tableView.reloadData()
    }
    
}

extension FavouritesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }
}

extension FavouritesTableViewController {
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: {
                switch self.currentGroup {
                case .items:
                    let selectedItem = self.isFiltering ? self.filteredItems[indexPath.row] : self.favItems[indexPath.row]
                    return DetailViewController(obj: selectedItem, group: .items)
                case .wardrobes:
                    let selectedWardrobe = self.isFiltering ? self.filteredWardrobes[indexPath.row] : self.favWardrobes[indexPath.row]
                    return DetailViewController(obj: selectedWardrobe, group: .wardrobes)
                case .villagers:
                    let selectedVillager = self.isFiltering ? self.filteredVillagers[indexPath.row] : self.favVillagers[indexPath.row]
                    return DetailViewController(obj: selectedVillager, group: .villagers)
                }
                
        },
            actionProvider: { _ in
                switch self.currentGroup {
                case .items:
                    let selectedItem = self.isFiltering ? self.filteredItems[indexPath.row] : self.favItems[indexPath.row]
                    return ShareHelper.shared.presentContextShare(obj: selectedItem, group: .items, toVC: self)
                case .wardrobes:
                    let selectedWardrobe = self.isFiltering ? self.filteredWardrobes[indexPath.row] : self.favWardrobes[indexPath.row]
                    return ShareHelper.shared.presentContextShare(obj: selectedWardrobe, group: .wardrobes, toVC: self)
                case .villagers:
                    let selectedVillager = self.isFiltering ? self.filteredVillagers[indexPath.row] : self.favVillagers[indexPath.row]
                    return ShareHelper.shared.presentContextShare(obj: selectedVillager, group: .villagers, toVC: self)
                }
        })
    }
    
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        guard let indexPath = configuration.identifier as? IndexPath else { return }
        
        switch self.currentGroup {
        case .items:
            let selectedItem = self.isFiltering ? self.filteredItems[indexPath.row] : self.favItems[indexPath.row]
            animator.addAnimations {
                let vc = self.storyboard!.instantiateViewController(withIdentifier: self.DETAIL_ID) as! DetailViewController
                vc.parseOject(from: .items, object: selectedItem)
                
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated: true, completion: nil)
            }
        case .wardrobes:
            let selectedWardrobe = self.isFiltering ? self.filteredWardrobes[indexPath.row] : self.favWardrobes[indexPath.row]
            animator.addAnimations {
                let vc = self.storyboard!.instantiateViewController(withIdentifier: self.DETAIL_ID) as! DetailViewController
                vc.parseOject(from: .wardrobes, object: selectedWardrobe)
                
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated: true, completion: nil)
            }
        case .villagers:
            let selectedVillager = self.isFiltering ? self.filteredVillagers[indexPath.row] : self.favVillagers[indexPath.row]
            animator.addAnimations {
                let vc = self.storyboard!.instantiateViewController(withIdentifier: self.DETAIL_ID) as! DetailViewController
                vc.parseOject(from: .villagers, object: selectedVillager)
                
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated: true, completion: nil)
            }
        }
    }
    
}
