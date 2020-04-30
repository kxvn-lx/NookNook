//
//  TurnipReminderTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 30/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class TurnipReminderTableViewController: UITableViewController {
    
    private var buyCell = TurnipTableViewCell()
    private var sellCell = TurnipTableViewCell()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
    }
    
    override func loadView() {
        super.loadView()
        
        buyCell = setupCell(text: "Buy reminder")
        sellCell = setupCell(text: "Sell reminder")
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return buyCell
        case 1: return sellCell
        default: fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0 : return 5
        default: return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.5)
        switch section {
        case 0: header.textLabel?.text = ""
        default: header.textLabel?.text = "Buy reminder will be always on sunday morning. while Sell reminder will be always on friday night."
        }
    }
    
    
    
    // MARK: - Setup views
    private func setBar() {
        self.configureNavigationBar(title: "Turnip reminder", preferredLargeTitle: false)
        self.view.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupCell(text: String) -> TurnipTableViewCell {
        let cell = TurnipTableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        cell.textLabel?.text = text
        cell.textLabel?.textColor =  UIColor(named: ColourUtil.dirt1.rawValue)
        
        return cell
    }
    
    
    
}
