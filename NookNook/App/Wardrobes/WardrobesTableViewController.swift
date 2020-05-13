//
//  WardrobesTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 15/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMobileAds
import SwipeCellKit

class WardrobesTableViewController: UITableViewController {
    // Constants
    let WARDROBE_CELL = "WardrobeCell"
    private let DETAIL_ID = "Detail"
    
    // Instance
    private var favouritesManager: DataPersistEngine!
    
    // General variables
    var wardrobes: [Wardrobe] = []
    var filteredWardrobes: [Wardrobe] = []
    var currentCategory: Categories = Categories.tops
    
    // SearchController properties
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // Google ads banner
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
        adBannerView.translatesAutoresizingMaskIntoConstraints = false
        adBannerView.adUnitID = GoogleAdsHelper.AD_UNIT_ID
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    // MARK: - Table views init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        // Default categories to be presented
        wardrobes = DataEngine.loadWardrobesJSON(from: currentCategory)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search \(wardrobes.count) wardrobes..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritesManager = DataPersistEngine()
        self.navigationController?.navigationBar.sizeToFit()
        self.tableView.reloadData()
        if !UDEngine.shared.getIsAdsPurchased() {
            self.view.addSubview(adBannerView)
            adBannerView.load(GADRequest())
            NSLayoutConstraint.activate([
                adBannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                adBannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            adBannerView.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self
        
        if !UDEngine.shared.getIsFirstVisit(on: .Wardrobes) {
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SwipeTableViewCell
            cell.showSwipe(orientation: .left, animated: true) { (sucess) in
                if sucess {
                    cell.hideSwipe(animated: true)
                    UDEngine.shared.saveIsFirstVisit(on: .Wardrobes)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        setupSearchBar(searchBar: searchController.searchBar)
    }
    
    private func setupSearchBar(searchBar: UISearchBar) {
        searchBar.setPlaceholderTextColorTo(color: UIColor.lightGray)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            if filteredWardrobes.isEmpty {
                self.tableView.setEmptyMessage("No wardrobe(s) found 😢.\nPerhaps you made a mistake?")
            } else {
                self.tableView.restore()
            }
            return filteredWardrobes.count
        }
        return wardrobes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WARDROBE_CELL, for: indexPath)
        
        if let wardrobeCell = cell as? WardrobetabTableViewCell {
            wardrobeCell.imgView.sd_imageTransition = .fade
            wardrobeCell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            wardrobeCell.delegate = self
            let wardrobe = isFiltering ? filteredWardrobes[indexPath.row] : wardrobes[indexPath.row]
            
            wardrobeCell.imgView.sd_setImage(with: ImageEngine.parseNPURL(with: wardrobe.image!, category: wardrobe.category), placeholderImage: UIImage(named: "placeholder"))
            wardrobeCell.nameLabel.text = wardrobe.name
            wardrobeCell.obtainedFromLabel.text = wardrobe.obtainedFrom
            wardrobeCell.buyLabel.attributedText = PriceEngine.renderPrice(amount: wardrobe.buy, with: .buy, of: 12)
            wardrobeCell.sellLabel.attributedText = PriceEngine.renderPrice(amount: wardrobe.sell, with: .sell, of: 12)
            
            wardrobeCell.isFavImageView.image = self.favouritesManager.wardrobes.contains(wardrobe) ?  IconHelper.systemIcon(of: IconHelper.IconName.starFill, weight: .thin) : nil
            if wardrobe.variants != nil {
                wardrobeCell.customisableImageView.image = IconHelper.systemIcon(of: IconHelper.IconName.paintbrush, weight: .thin)
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
        self.present(navController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .cream1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(currentCategory.rawValue.capitalizingFirstLetter())"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .cream1
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = .dirt1
    }
    
    // swipe right function
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let wardrobe: Wardrobe
        if self.isFiltering {
            wardrobe = self.filteredWardrobes[indexPath.row]
        } else {
            wardrobe = self.wardrobes[indexPath.row]
        }
        
        let favouriteAction = UIContextualAction(style: .normal, title: "", handler: { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            self.favouritesManager.saveWardrobe(wardrobe: wardrobe)
            DispatchQueue.main.async {
                let contentOffset = tableView.contentOffset
                self.tableView.reloadRows(at: [indexPath], with: .left)
                tableView.contentOffset = contentOffset
            }
            
            Taptic.lightTaptic()
            success(true)
        })
        
        favouriteAction.image = self.favouritesManager.wardrobes.contains(wardrobe) ? IconHelper.systemIcon(of: .starFill, weight: .thin) : IconHelper.systemIcon(of: .star, weight: .thin)
        favouriteAction.backgroundColor = .grass1
        
        return UISwipeActionsConfiguration(actions: [favouriteAction])
        
    }
    
    // MARK: - Modify UI
    private func setBar() {
        tabBarController?.tabBar.barTintColor = .grass1
        self.configureNavigationBar(title: "Wardrobes")
        self.tableView.backgroundColor = .cream2
        
        tabBarController?.tabBar.tintColor = .white
        
        let button: UIButton = UIButton(type: .custom)
        button.setImage(IconHelper.systemIcon(of: .filter, weight: .regular), for: .normal)
        button.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dirt1]
    }
    
    @objc private func filterButtonPressed() {
        let CAT_ID = "Categories"
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: CAT_ID) as! CategoriesTableViewController
        vc.filteredCategories = Categories.wardrobes()
        vc.catDelegate = self
        vc.currentCategory = currentCategory
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
}

// MARK: - Category delegate
extension WardrobesTableViewController: CatDelegate {
    func parseNewCategory(of category: Categories) {
        currentCategory = category
        wardrobes = DataEngine.loadWardrobesJSON(from: currentCategory)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
        searchController.searchBar.placeholder = "Search \(wardrobes.count) wardrobes..."
    }
}

// MARK: - SearchResults delegegate
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

// MARK: - Tabbarcontroller delegate
extension WardrobesTableViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 2 {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}

extension WardrobesTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .left else { return nil }
        
        let wardrobe = isFiltering ? self.filteredWardrobes[indexPath.row] : self.wardrobes[indexPath.row]
        
        let favouriteAction = SwipeAction(style: .default, title: nil) { (_, indexPath) in
            self.favouritesManager.saveWardrobe(wardrobe: wardrobe)
            let contentOffset = tableView.contentOffset
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .left)
                tableView.contentOffset = contentOffset
            }
            Taptic.lightTaptic()
        }
        
        favouriteAction.image = self.favouritesManager.wardrobes.contains(wardrobe) ? IconHelper.systemIcon(of: .starFill, weight: .thin) : IconHelper.systemIcon(of: .star, weight: .thin)
        favouriteAction.backgroundColor = .grass1
        
        return [favouriteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.backgroundColor = .grass1
        options.transitionStyle = .border
        return options
    }
}

extension WardrobesTableViewController {
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: {
                let selectedWardrobe = self.isFiltering ? self.filteredWardrobes[indexPath.row] : self.wardrobes[indexPath.row]
                return DetailViewController(obj: selectedWardrobe, group: .wardrobes)
            },
            actionProvider: { _ in
                let selectedWardrobe = self.isFiltering ? self.filteredWardrobes[indexPath.row] : self.wardrobes[indexPath.row]
                return ShareHelper.shared.presentContextShare(obj: selectedWardrobe, group: .wardrobes, toVC: self)
            })
    }
    
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        guard let indexPath = configuration.identifier as? IndexPath else { return }
        let selectedWardrobe = self.isFiltering ? self.filteredWardrobes[indexPath.row] : self.wardrobes[indexPath.row]
        
        animator.addAnimations {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: self.DETAIL_ID) as! DetailViewController
            vc.parseOject(from: .wardrobes, object: selectedWardrobe)
            
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true, completion: nil)
        }
    }

}
