//
//  FruitsTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 23/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

protocol FruitsDelegate : NSObjectProtocol {
    func changeFruit(fruit: Fruits)
}

class FruitsTableViewController: UITableViewController {

    private let FRUIT_CELL = "FruitCell"
    
    private var fruits: [Fruits] = []
    
    weak var fruitsDelegate: FruitsDelegate!
    
     override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 50

        tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        
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
        cell.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
    }
    
    private func setBar() {
        self.configureNavigationBar(largeTitleColor: UIColor(named: ColourUtil.dirt1.rawValue)!, backgoundColor: UIColor(named: ColourUtil.cream1.rawValue)!, tintColor: UIColor(named: ColourUtil.cream1.rawValue)!, title: "Change fruit", preferredLargeTitle: false)
        
        self.tableView.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeTapped))
        navigationItem.rightBarButtonItems = [cancel]
    }
    
    @objc func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
