//
//  OutfitFilterTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 10/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

protocol OutfitFilterDelegate: class {
    func filterDidToggleDress(withToggleResult isDress: Bool)
}

private let identifier = "reuseIdentifier"

class OutfitFilterTableViewController: UITableViewController {
    
    private var toggleDressCell = UITableViewCell()
    weak var delegate: OutfitFilterDelegate?
    
    var isDressTogled = false
    private let headerTitle = "Mix and match any outfit as you like! Once you are ready, tap the preview button to see it in a bigger picture. Once you are happy, you can save your outfit selection to your camera roll to show off your cool new outfit! 😎"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        tableView.tableFooterView = UIView()
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        self.addHeaderImage(withIcon: IconHelper.systemIcon(of: .outfit, weight: .regular), height: 100)
    }
    
    override func loadView() {
        super.loadView()
        
        toggleDressCell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        toggleDressCell.backgroundColor = .cream2
        toggleDressCell.textLabel?.textColor = .dirt1
        toggleDressCell.textLabel?.text = "Use dress instead"
        let mySwitch = UISwitch()
        mySwitch.addTarget(self, action: #selector(dressSwitchToggle), for: .valueChanged)
        mySwitch.isOn = isDressTogled
        toggleDressCell.accessoryView = mySwitch
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return toggleDressCell
            default: fatalError()
            }
        default: fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.detailTextLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        switch section {
        case 0: headerView.textLabel!.text = headerTitle
        default: headerView.textLabel!.text = ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return headerTitle
        default: return nil
        }
    }
    
    private func setBar() {
        self.configureNavigationBar(title: "Information and tweaks", preferredLargeTitle: false)
        self.view.backgroundColor = .cream1
        self.view.tintColor = .white
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dressSwitchToggle(_ sender: UISwitch) {
        delegate?.filterDidToggleDress(withToggleResult: sender.isOn)
    }
}
