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
        case BuyCoffee = "com.kevinlaminto.NookNook.BuyCoffee1"
        case RemoveAds = "com.kevinlaminto.NookNook.RemoveAds1"
        case RemoveAdsBuyCoffee = "com.kevinlaminto.NookNook.RemoveAdsBuyCoffee1"
    }
    
    // Table view cell properties
    private var removeAdsCell = UITableViewCell()
    private var buyMeCoffeeCell = UITableViewCell()
    private var removeAdsAndCoffeeCell = UITableViewCell()
    
    private var restoreCell = UITableViewCell()
    
    // MARK: - View init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        // Tableview properties
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        self.addHeaderImage(withIcon: IconHelper.systemIcon(of: .supportMe, weight: .regular))
        
        // SwiftyStoreKit properties
        SwiftyStoreKit.retrieveProductsInfo([IAPProduct.BuyCoffee.rawValue,
                                             IAPProduct.RemoveAds.rawValue,
                                             IAPProduct.RemoveAdsBuyCoffee.rawValue]) { result in
                                                for product in result.retrievedProducts {
                                                    print("Product: \(product.localizedTitle) - price: \(product.price)")
                                                }
                                                for product in result.invalidProductIDs {
                                                    print("Invalid product ID: \(product)")
                                                }
                                                if let error = result.error {
                                                    print(error.localizedDescription)
                                                }
        }
        SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in return true }
    }
    
    override func loadView() {
        super.loadView()
        removeAdsCell = setupCell(text: "Remove ads 🙌")
        buyMeCoffeeCell = setupCell(text: "Buy me a coffee ☕️")
        removeAdsAndCoffeeCell = setupCell(text: "Remove ads and buy me a coffee 🤩")
        restoreCell = setupCell(text: "Restore purchase")
        
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
            // Buy coffee
            case 0:
                SpinnerHelper.shared.present()
                SwiftyStoreKit.purchaseProduct(IAPProduct.BuyCoffee.rawValue, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let purchase):
                        Taptic.successTaptic()
                        let alert = AlertHelper.createDefaultAction(title: "Thank you ❤️", message: "\(String(describing: purchase.product.localizedTitle)) has been successfully purchased!")
                        self.present(alert, animated: true)
                        SpinnerHelper.shared.absent()
                        
                    case .error(let error):
                        switch error.code {
                        case .paymentCancelled:
                            SpinnerHelper.shared.absent()
                            
                        case .unknown, .storeProductNotAvailable:
                            Taptic.errorTaptic()
                            let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "There was problem with the transaction. Please try again later or contact kevin.laminto@gmail.com")
                            self.present(alert, animated: true)
                            SpinnerHelper.shared.absent()
                            
                        case .paymentInvalid, .paymentNotAllowed, .clientInvalid:
                            Taptic.errorTaptic()
                            let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "Your payment option seems to be invalid/not allowed. Please try again later or contact kevin.laminto@gmail.com")
                            self.present(alert, animated: true)
                            SpinnerHelper.shared.absent()
                            
                            
                        default: print((error as NSError).localizedDescription)
                        }
                    }
                }
                
            // Remove ads
            case 1:
                SpinnerHelper.shared.present()
                SwiftyStoreKit.purchaseProduct(IAPProduct.RemoveAds.rawValue, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let purchase):
                        Taptic.successTaptic()
                        UDEngine.shared.saveIsAdsPurchased()
                        let alert = AlertHelper.createDefaultAction(title: "Thank you ❤️", message: "\(String(describing: purchase.product.localizedTitle)) has been successfully purchased!")
                        self.present(alert, animated: true)
                        SpinnerHelper.shared.absent()
                        
                    case .error(let error):
                        switch error.code {
                        case .paymentCancelled:
                            SpinnerHelper.shared.absent()
                            
                        case .unknown, .storeProductNotAvailable:
                            Taptic.errorTaptic()
                            let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "There was problem with the transaction. Please try again later or contact kevin.laminto@gmail.com")
                            self.present(alert, animated: true)
                            SpinnerHelper.shared.absent()
                            
                        case .paymentInvalid, .paymentNotAllowed, .clientInvalid:
                            Taptic.errorTaptic()
                            let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "Your payment option seems to be invalid/not allowed. Please try again later or contact kevin.laminto@gmail.com")
                            self.present(alert, animated: true)
                            SpinnerHelper.shared.absent()
                            
                        default: print((error as NSError).localizedDescription)
                        }
                    }
                }
                
            // Remove ads + buy cofeee
            case 2:
                SpinnerHelper.shared.present()
                SwiftyStoreKit.purchaseProduct(IAPProduct.RemoveAdsBuyCoffee.rawValue, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let purchase):
                        Taptic.successTaptic()
                        UDEngine.shared.saveIsAdsPurchased()
                        let alert = AlertHelper.createDefaultAction(title: "Thank you ❤️", message: "\(String(describing: purchase.product.localizedTitle)) has been successfully purchased!")
                        self.present(alert, animated: true)
                        SpinnerHelper.shared.absent()
                        
                    case .error(let error):
                        switch error.code {
                        case .paymentCancelled:
                            SpinnerHelper.shared.absent()
                        case .unknown, .storeProductNotAvailable:
                            Taptic.errorTaptic()
                            let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "There was problem with the transaction. Please try again later or contact kevin.laminto@gmail.com")
                            self.present(alert, animated: true)
                            SpinnerHelper.shared.absent()
                            
                        case .paymentInvalid, .paymentNotAllowed, .clientInvalid:
                            Taptic.errorTaptic()
                            let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "Your payment option seems to be invalid/not allowed. Please try again later or contact kevin.laminto@gmail.com")
                            self.present(alert, animated: true)
                            SpinnerHelper.shared.absent()
                            
                        default: print((error as NSError).localizedDescription)
                        }
                    }
                }
                
            default: break
            }
        case 1:
            switch indexPath.row {
            // Restore
            case 0:
                SpinnerHelper.shared.present()
                SwiftyStoreKit.restorePurchases(atomically: true) { results in
                    if results.restoreFailedPurchases.count > 0 {
                        let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "There was problem restoring your purchase(s). Please try again later or contact kevin.laminto@gmail.com")
                        self.present(alert, animated: true)
                        SpinnerHelper.shared.absent()
                    }
                    else if results.restoredPurchases.count > 0 {
                        let alert = AlertHelper.createDefaultAction(title: "Restore sucessful!", message: "")
                        self.present(alert, animated: true)
                        results.restoredPurchases.forEach({
                            if $0.productId == IAPProduct.RemoveAds.rawValue || $0.productId == IAPProduct.RemoveAdsBuyCoffee.rawValue {
                                UDEngine.shared.saveIsAdsPurchased()
                            }
                        })
                        SpinnerHelper.shared.absent()
                    }
                    else {
                        let alert = AlertHelper.createDefaultAction(title: "Nothing to restore.", message: "")
                        self.present(alert, animated: true)
                        SpinnerHelper.shared.absent()
                    }
                }
            default: break
            }
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 44 * 1.5 : 5
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.detailTextLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let text = "By supporting me, you are supporting the app. Every supports matter in improving the app to make it better for each and every one of you ❤️"
        return section == 1 ? text : nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
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
