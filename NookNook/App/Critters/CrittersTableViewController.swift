//
//  CrittersTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 14/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class CrittersTableViewController: UITableViewController {
    // constants
    private let CRITTER_CELL = "CritterCell"
    private let DETAIL_ID = "Detail"
    
    // Instance
    private var favouritesManager: DataPersistEngine!
    
    // General variables
    var critters: [Critter] = []
    var filteredCritters: [Critter] = []
    var currentCategory: Categories = Categories.bugsMain
    
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
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    
    // MARK: - Table view init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        
        // Default categories to be presented
        critters = DataEngine.loadCritterJSON(from: currentCategory)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search \(critters.count) critters..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setBar()
        
        // Setup google ads
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "2077ef9a63d2b398840261c8221a0c9b" ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritesManager = DataPersistEngine()
        self.navigationController?.navigationBar.sizeToFit()
        self.tableView.reloadData()
        if !UDHelper.getIsAdsPurchased() {
            self.view.addSubview(adBannerView)
            adBannerView.load(GADRequest())
        } else {
            adBannerView.removeFromSuperview()
        }
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
            if filteredCritters.count == 0 {
                self.tableView.setEmptyMessage("No critter(s) found 😢.\nPerhaps you made a mistake?")
            }
            else {
                self.tableView.restore()
            }
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
            critterCell.imgView.sd_setImage(with: ImageEngine.parseAcnhURL(with: critter.image, of: critter.category, mediaType: .images), placeholderImage: UIImage(named: "placeholder"))
            
            critterCell.nameLabel.text = critter.name
            critterCell.obtainedFromLabel.text = critter.obtainedFrom.isEmpty ? "Location unknown" : critter.obtainedFrom
            critterCell.timeLabel.text = TimeMonthEngine.formatTime(of: critter.time)
            critterCell.sellLabel.attributedText = PriceEngine.renderPrice(amount: critter.sell, with: .sell, of: 12)
            critterCell.weatherLabel.text = critter.weather
            
            critterCell.rarityLabel.setTitle(critter.rarity, for: .normal)
            critterCell.rarityLabel.sizeToFit()
            
            let isDonated = self.favouritesManager.donatedCritters.contains(critter) ? "D" : ""
            let isCaught = self.favouritesManager.caughtCritters.contains(critter) ? "C" : ""
            
            critterCell.isDonatedLabel.text = isDonated
            critterCell.isCaughtLabel.text = isCaught
            
            critterCell.isDonatedLabel.isHidden =  self.favouritesManager.donatedCritters.contains(critter) ? false : true
            critterCell.isCaughtLabel.isHidden =  self.favouritesManager.caughtCritters.contains(critter) ? false : true
            
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
        cell.backgroundColor = .cream1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch currentCategory {
        case .bugsMain:
            return "Bugs"
        case .fishesMain:
            return "Fishes"
        default:
            return "No Category found!"
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .cream1
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = .dirt1
    }
    
    // swipe right function
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let critter: Critter
        if self.isFiltering {
            critter = self.filteredCritters[indexPath.row]
        } else {
            critter = self.critters[indexPath.row]
        }
        
        let caughtAction = UIContextualAction(style: .normal, title:  "Caught", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            self.favouritesManager.saveCaughtCritter(critter: critter)
            DispatchQueue.main.async {
                let contentOffset = tableView.contentOffset
                self.tableView.reloadRows(at: [indexPath], with: .left)
                tableView.contentOffset = contentOffset
            }
            Taptic.lightTaptic()
            success(true)
        })
        
        let donatedAction = UIContextualAction(style: .normal, title:  "Donated", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            var finished = false
            
            if !self.favouritesManager.caughtCritters.contains(critter) {
                self.favouritesManager.saveCaughtCritter(critter: critter)
                
                if self.favouritesManager.caughtCritters.contains(critter) && self.favouritesManager.donatedCritters.contains(critter) {
                    self.favouritesManager.saveDonatedCritter(critter: critter)
                    self.favouritesManager.saveCaughtCritter(critter: critter)
                    finished = true
                }
            }
            if !finished {
                self.favouritesManager.saveDonatedCritter(critter: critter)
            }
            DispatchQueue.main.async {
                let contentOffset = tableView.contentOffset
                self.tableView.reloadRows(at: [indexPath], with: .left)
                tableView.contentOffset = contentOffset
            }
            Taptic.lightTaptic()
            success(true)
        })
        
        caughtAction.backgroundColor = .gold1
        donatedAction.backgroundColor = .grass1
        
        return UISwipeActionsConfiguration(actions: [donatedAction, caughtAction])
        
    }
    
    
    // MARK: - Modify UI
    private func setBar() {
        tabBarController?.tabBar.barTintColor = .grass1
        self.configureNavigationBar(title: "Critters")
        self.tableView.backgroundColor = .cream1
        
        let button: UIButton = UIButton(type: .custom)
        button.setImage(IconUtil.systemIcon(of: .filter, weight: .regular), for: .normal)
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
        vc.filteredCategories = Categories.critters()
        vc.catDelegate = self
        vc.currentCategory = currentCategory
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    
}

// MARK: - Category Delegate
extension CrittersTableViewController: CatDelegate {
    func parseNewCategory(of category: Categories) {
        currentCategory = category
        critters = DataEngine.loadCritterJSON(from: currentCategory)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
        searchController.searchBar.placeholder = "Search \(critters.count) critters..."
    }
}

// MARK: - Search results delegate
extension CrittersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCritters = critters.filter { (critter: Critter) -> Bool in
            return critter.name.lowercased().contains(searchText.lowercased())
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Tabbarcontroller delegate
extension CrittersTableViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1 {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}
