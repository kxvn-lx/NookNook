//
//  CrittersMonthlyTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 23/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class CrittersMonthlyTableViewController: UITableViewController {

    private let CRITTERS_MONTHLY = "CrittersMonthlyVC"
    private let CRITTER_CELL = "CritterCell"
    private let DETAIL_ID = "Detail"
    
    private var favouritesManager = PersistEngine()
    
    private var currentGroup = GroupType.bugs
    private var userHemisphere: DateHelper.Hemisphere!
    
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
        parseCritter()
        setBar()
        scView = SCHelper.createSC(items: items)
        sc = scView.viewWithTag(1) as? UISegmentedControl
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action:  #selector(changeSource), for: .valueChanged)
  
        
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search critters..."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        userHemisphere = UDHelper.getUser()["hemisphere"].map { (DateHelper.Hemisphere(rawValue: $0) ?? DateHelper.Hemisphere.Southern) }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationItem.searchController = search
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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
    
    private func parseCritter() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        print(dateFormatter.string(from: Date()))
        
        var northernBugs: [Critter] = []
        var northernFishes: [Critter] = []
        
        var southernBugs: [Critter] = []
        var southernFishes: [Critter] = []
        
        let allBugs = DataEngine.loadCritterJSON(from: .bugsMain)
        let allFishes = DataEngine.loadCritterJSON(from: .fishesMain)
        
        switch userHemisphere {
        case .Northern:
            for bug in allBugs {
                if bug.activeMonthsN.contains(String(dateFormatter.string(from: Date()))) {
                    northernBugs.append(bug)
                }
            }
            for fish in allFishes {
                if fish.activeMonthsN.contains(String(dateFormatter.string(from: Date()))) {
                    northernFishes.append(fish)
                }
            }
        case .Southern:
            for bug in allBugs {
                if bug.activeMonthsS.contains(String(dateFormatter.string(from: Date()))) {
                    southernBugs.append(bug)
                }
            }
            for fish in allFishes {
                if fish.activeMonthsS.contains(String(dateFormatter.string(from: Date()))) {
                    southernFishes.append(fish)
                }
            }
        default: fatalError("Invalid Hemisphere passed")
        }
        
        print(southernBugs)
    }
    
}

extension CrittersMonthlyTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }
}
