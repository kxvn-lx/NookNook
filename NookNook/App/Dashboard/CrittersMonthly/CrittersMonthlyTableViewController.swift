//
//  CrittersMonthlyTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 23/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class CrittersMonthlyTableViewController: UITableViewController {
    
    private let CRITTERS_MONTHLY = "CrittersMonthlyVC"
    private let CRITTER_CELL = "CritterCell"
    private let DETAIL_ID = "Detail"
    
    private var favouritesManager = PersistEngine()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        userHemisphere = UDHelper.getUser()["hemisphere"].map { (DateHelper.Hemisphere(rawValue: $0) ?? DateHelper.Hemisphere.Southern) }
        (bugs, fishes) = CritterHelper.parseCritter(userHemisphere: userHemisphere ?? DateHelper.Hemisphere.Southern)
        
        setBar()
        
        scView = SCHelper.createSC(items: items)
        sc = scView.viewWithTag(1) as? UISegmentedControl
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action:  #selector(changeSource), for: .valueChanged)
        
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search critters..."
        
        self.isModalInPresentation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userHemisphere = UDHelper.getUser()["hemisphere"].map { (DateHelper.Hemisphere(rawValue: $0) ?? DateHelper.Hemisphere.Southern) }
        ( bugs, fishes ) = CritterHelper.parseCritter(userHemisphere: userHemisphere ?? DateHelper.Hemisphere.Southern)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationItem.searchController = search
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentGroup {
        case .bugs:
            if isFiltering {
                return filteredBugs.count
            } else {
                return bugs.count
            }
        case .fishes:
            if isFiltering {
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
            
            let critter: Critter!
            
            switch currentGroup {
            case .bugs:
                if isFiltering {
                    critter = filteredBugs[indexPath.row]
                } else {
                    critter = bugs[indexPath.row]
                }
            case .fishes:
                if isFiltering {
                    critter = filteredFishes[indexPath.row]
                } else {
                    critter = fishes[indexPath.row]
                }
            }
            
            critterCell.imgView.sd_setImage(with: ImageEngine.parseAcnhURL(with: critter.image, of: critter.category, mediaType: .images), placeholderImage: nil)
            
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
        cell.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
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
    
    // swipe right function
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let critter: Critter!
        
        switch currentGroup {
        case .bugs:
            if isFiltering {
                critter = filteredBugs[indexPath.row]
            } else {
                critter = bugs[indexPath.row]
            }
        case .fishes:
            if isFiltering {
                critter = filteredFishes[indexPath.row]
            } else {
                critter = fishes[indexPath.row]
            }
        }
        
        let caughtAction = UIContextualAction(style: .normal, title:  "Caught", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            if self.favouritesManager.donatedCritters.contains(critter) {
                self.favouritesManager.saveDonatedCritter(critter: critter)
            }
            
            self.favouritesManager.saveCaughtCritter(critter: critter)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .left)
            }
            Taptic.lightTaptic()
            success(true)
        })
        
        let donatedAction = UIContextualAction(style: .normal, title:  "Donated", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            if !self.favouritesManager.caughtCritters.contains(critter) {
                self.favouritesManager.saveCaughtCritter(critter: critter)
            }
            self.favouritesManager.saveDonatedCritter(critter: critter)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .left)
            }
            Taptic.lightTaptic()
            success(true)
        })
        
        
        caughtAction.backgroundColor = UIColor(named: ColourUtil.gold1.rawValue)
        donatedAction.backgroundColor = UIColor(named: ColourUtil.grass2.rawValue)
        
        return UISwipeActionsConfiguration(actions: [donatedAction, caughtAction])
        
    }
    
    @objc func changeSource(sender: UISegmentedControl) {
        Taptic.lightTaptic()
        switch sender.selectedSegmentIndex {
        case 0:
            self.currentGroup = .bugs
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case 1:
            self.currentGroup = .fishes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        default:
            fatalError("Invalid Segmented Control index.")
        }
    }
    
    private func setBar() {
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Critters this Month", preferredLargeTitle: false)
        
        self.view.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
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
