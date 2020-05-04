//
//  CategoriesTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 13/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol CatDelegate : NSObjectProtocol {
    func parseNewCategory(of category: Categories)
}

class CategoriesTableViewController: UITableViewController {
    
    let CAT_CELL = "CategoryCell"
    var filteredCategories: [Categories] = []
    var currentCategory: Categories!
    
    weak var catDelegate: CatDelegate?
    
    // Google ads banner
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        adBannerView.translatesAutoresizingMaskIntoConstraints = false
        adBannerView.adUnitID = GoogleAdsHelper.AD_UNIT_ID
        adBannerView.delegate = self
        adBannerView.rootViewController = self

        return adBannerView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 50

        
        tableView.tableFooterView = UIView()
        
        setBar()
        
        // Setup google ads
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "2077ef9a63d2b398840261c8221a0c9b" ]
        adBannerView.load(GADRequest())
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CAT_CELL, for: indexPath)
        
        var cat = filteredCategories[indexPath.row].rawValue
        
        if cat == Categories.bugsMain.rawValue {
            cat = "Bugs"
        }
        else if cat == Categories.fishesMain.rawValue {
            cat = "Fishes"
        }
        if let categoryCell = cell as? CategoryTableViewCell {
            categoryCell.textLabel!.text = cat.capitalizingFirstLetter()
            if filteredCategories[indexPath.row] == currentCategory {
                categoryCell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let catDelegate = catDelegate {
            catDelegate.parseNewCategory(of: filteredCategories[indexPath.row])
            Taptic.lightTaptic()
            closeTapped()
        } else {
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .cream2
        cell.textLabel?.textColor = .dirt1
    }
    
    private func setBar() {
        self.configureNavigationBar(title: "Categories", preferredLargeTitle: false)
        
        self.tableView.backgroundColor = .cream1
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeTapped))
        navigationItem.rightBarButtonItems = [cancel]
    }
    
    @objc func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
