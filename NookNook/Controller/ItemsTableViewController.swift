//
//  ItemsTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 11/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {

    let ITEM_CELL = "ItemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ITEM_CELL, for: indexPath)
        
        if let itemCell = cell as? ItemTableViewCell {
            itemCell.itemNameLabel.text = static_item.name
            itemCell.obtainedFromLabel.text = static_item.obtainedFrom
            itemCell.buyLabel.text = "Buy: \(static_item.buy!)"
            itemCell.sellLabel.text = "Sell: \(static_item.sell!)"
        }

        return cell
    }
    
    
}
