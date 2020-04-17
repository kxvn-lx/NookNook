//
//  CategoriesTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 13/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

protocol CatDelegate : NSObjectProtocol {
    func parseNewCategory(of category: Categories)
}

class CategoriesTableViewController: UITableViewController {
    
    let CAT_CELL = "CategoryCell"
    var filteredCategories: [Categories] = []
    var currentCategory: Categories!
    
    weak var catDelegate: CatDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 50

        
        tableView.tableFooterView = UIView()
        
        setBar()
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
            categoryCell.categoryNameLabel.text = cat
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
        cell.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
    }
    
    private func setBar() {
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Categories", preferredLargeTitle: false)
        
        self.tableView.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeTapped))
        navigationItem.rightBarButtonItems = [cancel]
    }
    
    @objc func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
