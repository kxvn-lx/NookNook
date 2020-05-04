//
//  InAppPurchaseViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 4/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class InAppPurchaseViewController: UITableViewController {
    
    enum IAPProduct: String, CaseIterable {
        case NookNookP = "com.kevinlaminto.NookNook.BuyCoffee1"
        case RemoveAds = "com.kevinlaminto.NookNook.RemoveAds1"
        case BuyCoffeeNookNookP = "com.kevinlaminto.NookNook.RemoveAdsBuyCoffee1"
    }
    private let SHARED_SECRET = "240ac530fe894dc48bb26124d3368a65"
    
    // Table view cell properties
    private var removeAdsCell = UITableViewCell()
    private var buyMeCoffeeCell = UITableViewCell()
    private var removeAdsAndCoffeeCell = UITableViewCell()
    
    private var restoreCell = UITableViewCell()
    
    private var isPurchasedLabel = PaddingLabel(withInsets: 10, 10, 20, 20)
    
    
    
    // MARK: - View init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        
        isPurchasedLabel.isHidden = true
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        
        SwiftyStoreKit.retrieveProductsInfo([IAPProduct.NookNookP.rawValue,
                                             IAPProduct.RemoveAds.rawValue,
                                             IAPProduct.BuyCoffeeNookNookP.rawValue])
        { result in
            for product in result.retrievedProducts {
                print("Product: \(product.localizedTitle) - price: \(String(describing: product.localizedPrice))")
            }
            for product in result.invalidProductIDs {
                print("Invalid product ID: \(product)")
            }
            if let error = result.error {
                print(error.localizedDescription)
            }
        }
        
        SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in
            return true
        }
    }
    
    override func loadView() {
        super.loadView()
        removeAdsCell = setupCell(text: "NookNook+ 🙌")
        buyMeCoffeeCell = setupCell(text: "Buy me a coffee ☕️")
        removeAdsAndCoffeeCell = setupCell(text: "NookNook+ and buy me a coffee 🤩")
        restoreCell = setupCell(text: "Restore purchase")
        
        isPurchasedLabel.text = "NookNook+"
        isPurchasedLabel.font = .preferredFont(forTextStyle: .caption1)
        isPurchasedLabel.textAlignment = .center
        isPurchasedLabel.layer.borderColor = UIColor.dirt1.cgColor
        isPurchasedLabel.textColor = .dirt1
        isPurchasedLabel.layer.borderWidth = 1
        isPurchasedLabel.layer.cornerRadius = 2.5
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return 1
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
        case 1:
            switch indexPath.row {
            case 0: return restoreCell
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
            case 0:
                SwiftyStoreKit.purchaseProduct(IAPProduct.NookNookP.rawValue, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let purchase):
                        Taptic.successTaptic()
                        let alert = AlertHelper.createDefaultAction(title: "Thank you for you generosity 🤩", message: "\(String(describing: purchase.product.localizedTitle)) has been successfully purchased.")
                        self.present(alert, animated: true)
                        
                    case .error(let error):
                        switch error.code {
                        case .unknown, .clientInvalid, .paymentInvalid, .paymentNotAllowed, .storeProductNotAvailable:
                            Taptic.errorTaptic()
                            let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "There was problem with the transaction. Please try again later or contact kevin.laminto@gmail.com")
                            self.present(alert, animated: true)
                            
                        default: print((error as NSError).localizedDescription)
                        }
                    }
                }
                
            case 1:
                SwiftyStoreKit.purchaseProduct(IAPProduct.RemoveAds.rawValue, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let purchase):
                        self.isPurchasedLabel.isHidden = false
                        Taptic.successTaptic()
                        UDHelper.saveIsAdsPurchased()
                        let alert = AlertHelper.createDefaultAction(title: "Thank you ❤️", message: "\(String(describing: purchase.product.localizedTitle)) has been successfully purchased.")
                        self.present(alert, animated: true)
                        
                    case .error(let error):
                        switch error.code {
                        case .unknown, .clientInvalid, .paymentInvalid, .paymentNotAllowed, .storeProductNotAvailable:
                            Taptic.errorTaptic()
                            let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "There was problem with the transaction. Please try again later or contact kevin.laminto@gmail.com")
                            self.present(alert, animated: true)
                            
                        default: print((error as NSError).localizedDescription)
                        }
                    }
                }
                
            case 2:
                SwiftyStoreKit.purchaseProduct(IAPProduct.BuyCoffeeNookNookP.rawValue, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let purchase):
                        self.isPurchasedLabel.isHidden = false
                        Taptic.successTaptic()
                        UDHelper.saveIsAdsPurchased()
                        let alert = AlertHelper.createDefaultAction(title: "Thank you ❤️", message: "\(String(describing: purchase.product.localizedTitle)) has been successfully purchased.")
                        self.present(alert, animated: true)
                        
                    case .error(let error):
                        switch error.code {
                        case .unknown, .clientInvalid, .paymentInvalid, .paymentNotAllowed, .storeProductNotAvailable:
                            Taptic.errorTaptic()
                            let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "There was problem with the transaction. Please try again later or contact kevin.laminto@gmail.com")
                            self.present(alert, animated: true)
                            
                        default: print((error as NSError).localizedDescription)
                        }
                    }
                }
                
            default: break
            }
        case 1:
            switch indexPath.row {
            case 0:
                SwiftyStoreKit.restorePurchases(atomically: true) { results in
                    if results.restoreFailedPurchases.count > 0 {
                        let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "There was problem with the restoration. Please try again later or contact kevin.laminto@gmail.com")
                        self.present(alert, animated: true)
                    }
                    else if results.restoredPurchases.count > 0 {
                        self.isPurchasedLabel.isHidden = false
                        let alert = AlertHelper.createDefaultAction(title: "Restore sucessful.", message: "")
                        self.present(alert, animated: true)
                        results.restoredPurchases.forEach({
                            if $0.productId == IAPProduct.RemoveAds.rawValue || $0.productId == IAPProduct.BuyCoffeeNookNookP.rawValue {
                                UDHelper.saveIsAdsPurchased()
                            }
                        })
                    }
                    else {
                        let alert = AlertHelper.createDefaultAction(title: "Nothing to restore.", message: "")
                        self.present(alert, animated: true)
                    }
                }
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
        case 0: return 350
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
            headerView.addSubview(isPurchasedLabel)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            isPurchasedLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                imageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
                imageView.heightAnchor.constraint(equalToConstant: 60),
                imageView.widthAnchor.constraint(equalToConstant: 60),
                
                label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 10),
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20 * 2),
                label.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.95),
                
                isPurchasedLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
                isPurchasedLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
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
