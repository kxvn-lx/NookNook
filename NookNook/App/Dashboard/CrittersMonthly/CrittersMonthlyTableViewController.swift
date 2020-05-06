//
//  CrittersMonthlyTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 23/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMobileAds
import SwipeCellKit

class CrittersMonthlyTableViewController: UITableViewController {
    
    private let CRITTERS_MONTHLY = "CrittersMonthlyVC"
    private let CRITTER_CELL = "CritterCell"
    private let DETAIL_ID = "Detail"
    
    private var favouritesManager = DataPersistEngine()
    
    weak var profileDelegate: ProfileDelegate!
    
    private var currentGroup = GroupType.bugs
    private var userHemisphere: DateHelper.Hemisphere?
    
    private var sc: UISegmentedControl!
    private var scView: UIView!
    
    private let items: [String] = [GroupType.bugs.rawValue.capitalizingFirstLetter(),
                                   GroupType.fishes.rawValue.capitalizingFirstLetter(),
    ]
    
    let search = UISearchController(searchResultsController: nil)
    
    private var bugs: [Critter] = []
    private var fishes: [Critter] = []
    
    private var filteredBugs: [Critter] = []
    private var filteredFishes: [Critter] = []
    
    var isSearchBarEmpty: Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return search.isActive && !isSearchBarEmpty
    }
    
    enum GroupType: String {
        case bugs, fishes
    }
    
    // Google ads banner
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        adBannerView.translatesAutoresizingMaskIntoConstraints = false
        adBannerView.adUnitID = GoogleAdsHelper.AD_UNIT_ID
        adBannerView.rootViewController = self

        return adBannerView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        userHemisphere = UDEngine.shared.getUser()["hemisphere"].map { (DateHelper.Hemisphere(rawValue: $0) ?? DateHelper.Hemisphere.Southern) }
        (bugs, fishes) = CritterHelper.parseCritter(userHemisphere: userHemisphere ?? DateHelper.Hemisphere.Southern)
        
        setBar()
        
        scView = SCHelper.createSCWithTitle(title: userHemisphere?.rawValue ?? DateHelper.Hemisphere.Southern.rawValue, items: items)
        sc = scView.viewWithTag(1) as? UISegmentedControl
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action:  #selector(changeSource), for: .valueChanged)
        
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search critters..."
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        self.isModalInPresentation = true
        
        // Setup google ads
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "2077ef9a63d2b398840261c8221a0c9b" ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userHemisphere = UDEngine.shared.getUser()["hemisphere"].map { (DateHelper.Hemisphere(rawValue: $0) ?? DateHelper.Hemisphere.Southern) }
        ( bugs, fishes ) = CritterHelper.parseCritter(userHemisphere: userHemisphere ?? DateHelper.Hemisphere.Southern)
        
        if !UDEngine.shared.getIsAdsPurchased() {
            self.view.addSubview(adBannerView)
            adBannerView.load(GADRequest())
            NSLayoutConstraint.activate([
                adBannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                adBannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            ])
        } else {
            adBannerView.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UDEngine.shared.getIsFirstVisit(on: .CrittersThisMonth) {
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SwipeTableViewCell
            cell.showSwipe(orientation: .left, animated: true) { (sucess) in
                if sucess {
                    cell.hideSwipe(animated: true)
                    UDEngine.shared.saveIsFirstVisit(on: .CrittersThisMonth)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentGroup {
        case .bugs:
            if isFiltering {
                if filteredBugs.count == 0 {
                    self.tableView.setEmptyMessage("No bugs(s) found 😢.\nPerhaps you made a mistake?")
                } else {
                    self.tableView.restore()
                }
                return filteredBugs.count
            } else {
                return bugs.count
            }
        case .fishes:
            if isFiltering {
                if filteredBugs.count == 0 {
                    self.tableView.setEmptyMessage("No fish(s) found 😢.\nPerhaps you made a mistake?")
                } else {
                    self.tableView.restore()
                }
                return filteredFishes.count
            } else {
                return fishes.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CRITTER_CELL, for: indexPath)
        if let critterCell = cell as? CritterTableViewCell {
            critterCell.imgView.sd_imageTransition = .fade
            critterCell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            critterCell.delegate = self
            let critter: Critter!
            
            switch currentGroup {
            case .bugs:
                critter = isFiltering ? filteredBugs[indexPath.row] : bugs[indexPath.row]
            case .fishes:
                critter = isFiltering ? filteredFishes[indexPath.row] : fishes[indexPath.row]
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .cream1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: DETAIL_ID) as! DetailViewController
        
        switch currentGroup {
        case .bugs:
            if isFiltering {
                vc.parseOject(from: .critters, object: filteredBugs[indexPath.row])
            } else {
                vc.parseOject(from: .critters, object: bugs[indexPath.row])
            }
        case .fishes:
            if isFiltering {
                vc.parseOject(from: .critters, object: filteredFishes[indexPath.row])
            } else {
                vc.parseOject(from: .critters, object: fishes[indexPath.row])
            }
        }
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return scView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

    @objc func changeSource(sender: UISegmentedControl) {
        Taptic.lightTaptic()
        switch sender.selectedSegmentIndex {
        case 0:
            self.currentGroup = .bugs
        case 1:
            self.currentGroup = .fishes
        default:
            fatalError("Invalid Segmented Control index.")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setBar() {
        self.configureNavigationBar(title: "Critters this month", preferredLargeTitle: false)
        self.view.backgroundColor = .cream1
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    @objc private func closeTapped() {
        if let profileDelegate = profileDelegate {
            profileDelegate.updateprofile()
        }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        switch currentGroup {
        case .bugs:
            filteredBugs = bugs.filter { (bug: Critter) -> Bool in
                return bug.name.lowercased().contains(searchText.lowercased())
            }
            
        case .fishes:
            filteredFishes = fishes.filter { (fish: Critter) -> Bool in
                return fish.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
}

extension CrittersMonthlyTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }
}


extension CrittersMonthlyTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .left else { return nil }
        
        let critter: Critter!
        
        switch currentGroup {
        case .bugs:
            critter = isFiltering ? filteredBugs[indexPath.row] : bugs[indexPath.row]
        case .fishes:
            critter = isFiltering ? filteredFishes[indexPath.row] : fishes[indexPath.row]
        }
        
        let donatedAction = SwipeAction(style: .default, title: "Donated") { (action, indexPath) in
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
            let contentOffset = tableView.contentOffset
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .left)
                tableView.contentOffset = contentOffset
            }
            Taptic.lightTaptic()
        }
        
        let caughtAction = SwipeAction(style: .default, title: "Caught") { (action, indexPath) in
            self.favouritesManager.saveCaughtCritter(critter: critter)
            let contentOffset = tableView.contentOffset
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .left)
                tableView.contentOffset = contentOffset
            }
            Taptic.lightTaptic()
        }
        
        donatedAction.backgroundColor = .grass1
        caughtAction.backgroundColor = .gold1
        
        
        return [donatedAction, caughtAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.backgroundColor = .gold1
        options.transitionStyle = .border
        return options
    }
}
