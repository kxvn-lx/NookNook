//
//  WardrobesTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 15/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class WardrobesTableViewController: UITableViewController {
    
    let WARDROBE_CELL = "WardrobeCell"
    private let DETAIL_ID = "Detail"
    
    private var favouritesManager: PersistEngine!
    
    var wardrobes: [Wardrobe] = []
    var filteredWardrobes: [Wardrobe] = []
    var currentCategory: Categories = Categories.tops
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        // Default categories to be presented
        wardrobes = DataEngine.loadWardrobesJSON(from: currentCategory)
        
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search \(wardrobes.count) wardrobes..."
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritesManager = PersistEngine()
        self.tableView.reloadData()
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
            return filteredWardrobes.count
        }
        return wardrobes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WARDROBE_CELL, for: indexPath)
        
        if let wardrobeCell = cell as? WardrobetabTableViewCell {
            wardrobeCell.imgView.sd_imageTransition = .fade
            wardrobeCell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            let wardrobe: Wardrobe
            if isFiltering {
                wardrobe = filteredWardrobes[indexPath.row]
            } else {
                wardrobe = wardrobes[indexPath.row]
            }
            
            wardrobeCell.imgView.sd_setImage(with: ImageEngine.parseNPURL(with: wardrobe.image!, category: wardrobe.category), placeholderImage: nil)
            wardrobeCell.nameLabel.text = wardrobe.name
            wardrobeCell.obtainedFromLabel.text = wardrobe.obtainedFrom
            wardrobeCell.buyLabel.attributedText = PriceEngine.renderPrice(amount: wardrobe.buy, with: .buy, of: 12)
            wardrobeCell.sellLabel.attributedText = PriceEngine.renderPrice(amount: wardrobe.sell, with: .sell, of: 12)
            
            wardrobeCell.isFavImageView.image = self.favouritesManager.wardrobes.contains(wardrobe) ?  IconUtil.systemIcon(of: IconUtil.IconName.starFill, weight: .thin) : nil
            if wardrobe.variants != nil {
                wardrobeCell.customisableImageView.image = IconUtil.systemIcon(of: IconUtil.IconName.paintbrush, weight: .thin)
            } else {
                wardrobeCell.customisableImageView.image = nil
            }
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem: Wardrobe
        if isFiltering {
            selectedItem = filteredWardrobes[indexPath.row]
        } else {
            selectedItem = wardrobes[indexPath.row]
        }
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: DETAIL_ID) as! DetailViewController
        
        vc.parseOject(from: .wardrobes, object: selectedItem)
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(currentCategory.rawValue.capitalizingFirstLetter())"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
    }
    
    // swipe right function
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let wardrobe: Wardrobe
        if self.isFiltering {
            wardrobe = self.filteredWardrobes[indexPath.row]
        } else {
            wardrobe = self.wardrobes[indexPath.row]
        }
        
        let favouriteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.favouritesManager.saveWardrobe(wardrobe: wardrobe)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .left)
            }
            
            Taptic.lightTaptic()
            success(true)
        })

        favouriteAction.image = self.favouritesManager.wardrobes.contains(wardrobe) ? IconUtil.systemIcon(of: .starFill, weight: .thin) : IconUtil.systemIcon(of: .star, weight: .thin)
        favouriteAction.backgroundColor = UIColor(named: ColourUtil.grass2.rawValue)
        
        return UISwipeActionsConfiguration(actions: [favouriteAction])
        
    }
    
    // Modify the UI
    private func setBar() {
        tabBarController?.tabBar.barTintColor = UIColor(named: ColourUtil.grass1.rawValue)
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Wardrobes", preferredLargeTitle: true)
        
        self.tableView.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
        tabBarController?.tabBar.tintColor = .white
        
        let button: UIButton = UIButton(type: .custom)
        button.setImage(IconUtil.systemIcon(of: .filter, weight: .regular), for: .normal)
        button.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @objc private func filterButtonPressed() {
        let CAT_ID = "Categories"
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: CAT_ID) as! CategoriesTableViewController
        vc.filteredCategories = Categories.wardrobes()
        vc.catDelegate = self
        vc.currentCategory = currentCategory
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    
}

extension WardrobesTableViewController: CatDelegate {
    func parseNewCategory(of category: Categories) {
        currentCategory = category
        wardrobes = DataEngine.loadWardrobesJSON(from: currentCategory)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        searchController.searchBar.placeholder = "Search \(wardrobes.count) wardrobes..."
    }
}

extension WardrobesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredWardrobes = wardrobes.filter { (item: Wardrobe) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
