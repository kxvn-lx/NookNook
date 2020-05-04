//
//  AdsTableViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 4/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import StoreKit
import GoogleMobileAds

class AdsTableViewController: UITableViewController {

    
    // Google ads banner
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        adBannerView.translatesAutoresizingMaskIntoConstraints = false
        adBannerView.adUnitID = GoogleAdsHelper.AD_UNIT_ID
        adBannerView.delegate = self
        adBannerView.rootViewController = self

        return adBannerView
    }()
    
    // Table view cell properties
    private var removeAdsCell = UITableViewCell()
    private var buyMeCoffeeCell = UITableViewCell()
    private var removeAdsAndCoffeeCell = UITableViewCell()
    
    private var restoreCell = UITableViewCell()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        
        // Setup google ads
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "2077ef9a63d2b398840261c8221a0c9b" ]
        adBannerView.load(GADRequest())
        
        IAPService.shared.getProducts()
    }
    
    override func loadView() {
        super.loadView()
        removeAdsCell = setupCell(text: "Remove ads 🙌")
        buyMeCoffeeCell = setupCell(text: "Buy me a coffee ☕️")
        removeAdsAndCoffeeCell = setupCell(text: "Remove ads + buy me a coffee 🤩")
        restoreCell = setupCell(text: "Restore 'Remove ads' purchase")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return buyMeCoffeeCell
            case 1: return removeAdsCell
            case 2: return removeAdsAndCoffeeCell
            default: return UITableViewCell()
            }
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: IAPService.shared.purchase(product: .BuyCoffee)
            case 1: IAPService.shared.purchase(product: .RemoveAds)
            case 2: IAPService.shared.purchase(product: .RemoveAdsBuyCoffee)
            default: break
            }
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 300
        default: return .nan
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = UIView()
            let imageView = UIImageView()
            let label = UILabel()
            
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .dirt1
            imageView.image = IconUtil.systemIcon(of: .supportMe, weight: .regular).withRenderingMode(.alwaysTemplate)
            
            
            label.numberOfLines = 0
            label.text =
            """
            Hey there! I'm Kevin, the creator of NookNook.
            I'd really appreciate it if you'd take the time to support me with this app.
            I made NookNook to improve my ACNH experience and I hope you'll feel the same!
            
            This app would never be possible with your support. So to keep it like this in the future,
            any means of support is greatly appreaciated! 😁
            
            Thanks,
            Kevin.
            """
            label.lineBreakMode = .byWordWrapping
            label.textColor = UIColor.dirt1.withAlphaComponent(0.5)
            label.font = .preferredFont(forTextStyle: .caption1)
            
            
            headerView.addSubview(imageView)
            headerView.addSubview(label)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                imageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
                imageView.heightAnchor.constraint(equalToConstant: 60),
                imageView.widthAnchor.constraint(equalToConstant: 60),
                
                label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 10),
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20 * 2),
                label.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.95)
            ])
            return headerView
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.detailTextLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
    }
    

    // MARK: - Setup views
    private func setBar() {
        self.configureNavigationBar(title: "Support me", preferredLargeTitle: false)
        self.view.backgroundColor = .cream1
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    private func setupCell(text: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.backgroundColor = .cream2
        cell.textLabel?.text = text
        cell.textLabel?.textColor =  .grass1
        cell.accessoryType = .none
        
        return cell
    }
}
