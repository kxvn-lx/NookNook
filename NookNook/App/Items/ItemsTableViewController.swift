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
import WhatsNewKit
import GoogleMobileAds
import SwipeCellKit

class ItemsTableViewController: UITableViewController {
    // constants
    private let ITEM_CELL = "ItemCell"
    private let DETAIL_ID = "Detail"
    
    // general variables
    var items: [Item] = []
    var filteredItems: [Item] = []
    var currentCategory: Categories = Categories.housewares
    
    // instance
    private var favouritesManager: DataPersistEngine!
    private var whatsNewVC = WhatsNewHelper()
    
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
    
    // MARK: - Table view init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        setBar()
        
        // Default categories to be presented
        items = DataEngine.loadItemJSON(from: currentCategory)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search \(items.count) items..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Whatsnew Properties
        whatsNewVC.delegate = self
        guard let vc = whatsNewVC.view else {
            return
        }
        self.present(vc, animated: true)
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
        
        if !UDEngine.shared.getIsFirstVisit(on: .Item) {
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SwipeTableViewCell
            cell.showSwipe(orientation: .left, animated: true) { (sucess) in
                if sucess {
                    cell.hideSwipe(animated: true)
                    UDEngine.shared.saveIsFirstVisit(on: .Item)
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
            if filteredItems.isEmpty {
                self.tableView.setEmptyMessage("No item(s) found 😢.\nPerhaps you made a mistake?")
            } else {
                self.tableView.restore()
            }
            return filteredItems.count
        }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ITEM_CELL, for: indexPath)
        
        if let itemCell = cell as? ItemTableViewCell {
            itemCell.imgView.sd_imageTransition = .fade
            itemCell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            itemCell.delegate = self
            
            let item = isFiltering ? filteredItems[indexPath.row] : items[indexPath.row]
            
            itemCell.buyLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
            itemCell.sellLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
            
            itemCell.imgView.sd_setImage(with: ImageEngine.parseNPURL(with: item.image!, category: item.category), placeholderImage: UIImage(named: "placeholder"))
            itemCell.nameLabel.text = item.name
            itemCell.obtainedFromLabel.text = item.obtainedFrom
            itemCell.buyLabel.attributedText = PriceEngine.renderPrice(amount: item.buy, with: .buy, of: itemCell.buyLabel.font.pointSize)
            itemCell.sellLabel.attributedText = PriceEngine.renderPrice(amount: item.sell, with: .sell, of: itemCell.sellLabel.font.pointSize)
            
            itemCell.isFavImageView.image = self.favouritesManager.items.contains(item) ?  IconHelper.systemIcon(of: IconHelper.IconName.starFill, weight: .thin) : nil
            if item.variants != nil {
                itemCell.customisableImageView.image = IconHelper.systemIcon(of: IconHelper.IconName.paintbrush, weight: .thin)
            } else {
                itemCell.customisableImageView.image = nil
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = isFiltering ? filteredItems[indexPath.row] : items[indexPath.row]
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: DETAIL_ID) as! DetailViewController
        vc.parseOject(from: .items, object: selectedItem)
        
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
    
    // MARK: - Modify UI
    private func setBar() {
        tabBarController?.tabBar.barTintColor = .grass1
        self.configureNavigationBar(title: "Items")
        self.tableView.backgroundColor = .cream1
        
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
        vc.filteredCategories = Categories.items()
        vc.catDelegate = self
        vc.currentCategory = currentCategory
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
}

// MARK: - Category Delegate
extension ItemsTableViewController: CatDelegate {
    func parseNewCategory(of category: Categories) {
        currentCategory = category
        items = DataEngine.loadItemJSON(from: currentCategory)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        searchController.searchBar.placeholder = "Search \(items.count) items..."
    }
}

// MARK: - SearchResults Delegate
extension ItemsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredItems = items.filter { (item: Item) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Tabbarcontroller delegate
extension ItemsTableViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}

extension ItemsTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .left else { return nil }
        
        let item = self.isFiltering ? self.filteredItems[indexPath.row] : self.items[indexPath.row]
        
        let favouriteAction = SwipeAction(style: .default, title: nil) { (_, indexPath) in
            self.favouritesManager.saveItem(item: item)
            let contentOffset = tableView.contentOffset
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .left)
                tableView.contentOffset = contentOffset
            }
            Taptic.lightTaptic()
        }
        
        favouriteAction.image = self.favouritesManager.items.contains(item) ? IconHelper.systemIcon(of: .starFill, weight: .thin) : IconHelper.systemIcon(of: .star, weight: .thin)
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

extension ItemsTableViewController: WhatsNewhelperDelegate {
    func whatsNewDidFinish(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SwipeTableViewCell
        cell.showSwipe(orientation: .left, animated: true) { (sucess) in
            if sucess {
                cell.hideSwipe(animated: true)
                UDEngine.shared.saveIsFirstVisit(on: .Item)
            }
        }
    }
}
