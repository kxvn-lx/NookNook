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

enum IAPProduct: String, CaseIterable {
    case BuyCoffee = "com.kevinlaminto.NookNook.BuyCoffee1"
    case BuyMeal = "com.kevinlaminto.NookNook.BuyMeal1"
}

class InAppPurchaseViewController: UITableViewController {
    
    // Table view cell properties
    private var products: [SKProduct] = []
    private let emojis = ["☕️", "🍱"]
    
    // MARK: - View init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start spinner animation before loading the products
        SpinnerHelper.shared.present()
        
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
                                             IAPProduct.BuyCoffee.rawValue]) { result in
                                                for product in result.retrievedProducts {
                                                    print("✅ Product: \(product.localizedTitle) - price: $\(product.price)")
                                                    self.products.append(product)
                                                }
                                                for product in result.invalidProductIDs {
                                                    print("❗️Invalid product ID: \(product)")
                                                }
                                                if let error = result.error {
                                                    print("❗️ERROR RETRIEVING PRODUCTS: \(error.localizedDescription)")
                                                }
                                                self.products = self.products.sorted(by: {$0.localizedTitle < $1.localizedTitle})
                                                SpinnerHelper.shared.absent()
                                                self.tableView.reloadData()
        }
        SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in return true }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "productCell")
        
        if !products.isEmpty {
            cell.textLabel?.text = "\(products[indexPath.row].localizedTitle) \(emojis[indexPath.row])"
            cell.detailTextLabel?.text = "\(products[indexPath.row].price)"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            // Present a spinner before taking request
            SpinnerHelper.shared.present()
            
            SwiftyStoreKit.purchaseProduct(products[indexPath.row]) { (result) in
                switch result {
                case .success:
                    SpinnerHelper.shared.absent()

                case .error(let error):
                    switch error.code {
                    case .paymentCancelled: SpinnerHelper.shared.absent()
                        
                    case .unknown:
                        SpinnerHelper.shared.absent()
                        Taptic.errorTaptic()
                        let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "There was a problem with the transaction. Please contact kevin.laminto@gmail.com if problem persist.")
                        self.present(alert, animated: true)
                        
                    case .storeProductNotAvailable:
                        SpinnerHelper.shared.absent()
                        Taptic.errorTaptic()
                        let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "Looks like the product does not exist on the sever. Please contact kevin.laminto@gmail.com")
                        self.present(alert, animated: true)
                        
                    case .paymentInvalid, .paymentNotAllowed, .clientInvalid:
                        SpinnerHelper.shared.absent()
                        Taptic.errorTaptic()
                        let alert = AlertHelper.createDefaultAction(title: "Something went wrong.", message: "Looks like the your payment is invalid. Please contact kevin.laminto@gmail.com if problem persist.")
                        self.present(alert, animated: true)
                        
                    default: print(error.localizedDescription)
                    }
                }
            }
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.detailTextLabel?.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        cell.backgroundColor = .cream2
        cell.textLabel?.textColor =  .grass1
        cell.accessoryType = .none
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let text =
        """
            By supporting me, you are supporting the app. Every supports matter in improving the app to make it better for each and every one of you ❤️

            Terms And Condition + Privacy Policy are available via the website.
            """
        return text
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
}
