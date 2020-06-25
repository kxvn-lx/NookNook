//
//  FruitsTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 23/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

protocol FruitsDelegate: NSObjectProtocol {
    func changeFruit(fruit: Fruits)
}

class FruitsTableViewController: UITableViewController {

    private let FRUIT_CELL = "FruitCell"
    
    private var fruits: [Fruits] = []
    var userFruit: String!
    
    weak var fruitsDelegate: FruitsDelegate!
    
     override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: FRUIT_CELL)
        
        tableView.rowHeight = 50

        tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .singleLine
        
        setBar()
        
        // Iterate over fruits to fill the array
        Fruits.allCases.forEach {
            fruits.append($0)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Fruits.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FRUIT_CELL, for: indexPath)
        cell.textLabel?.text = fruits[indexPath.row].rawValue
        
        if let selectedFruit = userFruit {
            if fruits[indexPath.row].rawValue == selectedFruit {
                cell.accessoryType = .checkmark
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let fruitDelegate = fruitsDelegate {
            fruitDelegate.changeFruit(fruit: fruits[indexPath.row])
            Taptic.lightTaptic()
            closeTapped()
        } else {
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .cream2
    }
    
    private func setBar() {
        self.configureNavigationBar(title: "Change fruit", preferredLargeTitle: false)
        self.tableView.backgroundColor = .cream1
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeTapped))
        navigationItem.rightBarButtonItems = [cancel]
    }
    
    @objc func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
