//
//  FavouritesTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 20/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class FavouritesTableViewController: UITableViewController {

    private let FAVOURITE_CELL = "FavouriteCell"
    private let DETAIL_ID = "Detail"
    
    private let favouritesManager = PersistEngine()
    
    private var currentGroup = GroupType.items
    
    private var sc: UISegmentedControl!
    private var scView: UIView!
    
    private let items: [String] = [GroupType.items.rawValue.capitalizingFirstLetter(),
                           GroupType.wardrobes.rawValue.capitalizingFirstLetter(),
                           GroupType.villagers.rawValue.capitalizingFirstLetter()
    ]
    
    enum GroupType: String {
        case items, wardrobes, villagers
    }
    
    private var favItems: [Item] = []
    private var favWardrobes: [Wardrobe] = []
    private var favVillagers: [Villager] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        setBar()
        scView = SCHelper.createSC(items: items)
        sc = scView.viewWithTag(1) as? UISegmentedControl
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action:  #selector(changeSource), for: .valueChanged)
        
        favItems = favouritesManager.items
        favVillagers = favouritesManager.favouritedVillagers
        favWardrobes = favouritesManager.wardrobes
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentGroup {
        case .items:
            return favouritesManager.items.count
        case .wardrobes:
            return favouritesManager.wardrobes.count
        case .villagers:
            return favouritesManager.favouritedVillagers.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FAVOURITE_CELL, for: indexPath)
        switch currentGroup {
        case .items:
            let objs = favItems[indexPath.row]
            sc.selectedSegmentIndex = 0
            if let cell = cell as? FavouriteTableViewCell {
                cell.imgView.sd_imageTransition = .fade
                cell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                
                cell.imgView.sd_setImage(with: ImageEngine.parseNPURL(with: objs.image!), placeholderImage: nil)
                cell.nameLabel.text = objs.name
                cell.label1.text = objs.obtainedFrom
                cell.label3.attributedText = PriceEngine.renderPrice(amount: objs.buy, with: .buy, of: 12)
                cell.label4.attributedText = PriceEngine.renderPrice(amount: objs.sell, with: .sell, of: 12)
                
                
                cell.iconLabel1.isHidden = true
                cell.iconLabel2.isHidden = true
                cell.tagLabel.isHidden = true
                cell.label3.font = UIFont.systemFont(ofSize: cell.label3.font!.pointSize, weight: .regular)
            }
        case .villagers:
            let objs = favVillagers[indexPath.row]
            sc.selectedSegmentIndex = 2
            if let cell = cell as? FavouriteTableViewCell {
                cell.imgView.sd_imageTransition = .fade
                cell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                
                cell.imgView.sd_setImage(with: ImageEngine.parseAcnhURL(with: objs.image, of: objs.category, mediaType: .icons), placeholderImage: nil)
                cell.nameLabel.text = objs.name
                cell.label1.text = objs.species
                cell.tagLabel.setTitle(objs.personality, for: .normal)
                cell.label3.text = objs.bdayString
                cell.label4.text = objs.gender
                
                cell.tagLabel.isHidden = false
                cell.label3.font = UIFont.systemFont(ofSize: cell.label3.font!.pointSize, weight: .semibold)
            }
        case.wardrobes:
            let objs = favWardrobes[indexPath.row]
            sc.selectedSegmentIndex = 1
            if let cell = cell as? FavouriteTableViewCell {
                cell.imgView.sd_imageTransition = .fade
                cell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                
                cell.imgView.sd_setImage(with: ImageEngine.parseNPURL(with: objs.image!), placeholderImage: nil)
                cell.nameLabel.text = objs.name
                cell.label1.text = objs.obtainedFrom
                cell.label3.attributedText = PriceEngine.renderPrice(amount: objs.buy, with: .buy, of: 12)
                cell.label4.attributedText = PriceEngine.renderPrice(amount: objs.sell, with: .sell, of: 12)
                
                
                cell.iconLabel1.isHidden = true
                cell.iconLabel2.isHidden = true
                cell.tagLabel.isHidden = true
                cell.label3.font = UIFont.systemFont(ofSize: cell.label3.font!.pointSize, weight: .regular)
                
            }
        }
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: DETAIL_ID) as! DetailViewController
        
        switch currentGroup {
        case .items:
            vc.parseOject(from: .items, object: favItems[indexPath.row])
        case .wardrobes:
            vc.parseOject(from: .wardrobes, object: favWardrobes[indexPath.row])
        case .villagers:
            vc.parseOject(from: .villagers, object: favVillagers[indexPath.row])
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
        switch sender.selectedSegmentIndex {
        case 0:
            self.currentGroup = .items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case 1:
            self.currentGroup = .wardrobes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case 2:
            self.currentGroup = .villagers
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        default:
            fatalError("Invalid Segmented Control index.")
        }
    }
    
    private func setBar() {
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Favourites", preferredLargeTitle: false)
        
        self.view.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

}
