//
//  IAPService.swift
//  NookNook
//
//  Created by Kevin Laminto on 4/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import StoreKit

class IAPService: NSObject {
    
    enum IAPProduct: String, CaseIterable {
        case RemoveAds = "com.kevinlaminto.NookNook.RemoveAds1"
        case BuyCoffee = "com.kevinlaminto.NookNook.BuyCoffee1"
        case RemoveAdsBuyCoffee = "com.kevinlaminto.NookNook.RemoveAdsBuyCoffee1"
    }
    
    private override init() { }
    static let shared = IAPService()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    /// Get all the IN-App products
    func getProducts() {
        let products: Set = [IAPProduct.RemoveAds.rawValue,
                             IAPProduct.BuyCoffee.rawValue,
                             IAPProduct.RemoveAdsBuyCoffee.rawValue,
        ]
        guard products.count == IAPProduct.allCases.count else {
            fatalError("Please ensure all products has been registered.")
        }
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    
    /// Purchase the selected product
    /// - Parameter product: The product ready to be purchased
    func purchase(product: IAPProduct) {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else {
            print("Can't find product")
            return
        }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    /// Restoring purchased product
    func restore() {
        paymentQueue.restoreCompletedTransactions()
    }
    
}


extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print("\(transaction.payment.productIdentifier) - \(transaction.transactionState.status())")
            
            switch transaction.transactionState {
            case .purchasing: break
            case .purchased:
                if transaction.payment.productIdentifier == IAPProduct.RemoveAds.rawValue ||
                    transaction.payment.productIdentifier == IAPProduct.RemoveAdsBuyCoffee.rawValue {
                    UDHelper.saveIsAdsPurchased()
                }
                queue.finishTransaction(transaction)
                
            case .failed:
                queue.finishTransaction(transaction)
                
            default: queue.finishTransaction(transaction)
            }
            
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred: return "Deferred"
        case .failed: return "Failed"
        case .purchased: return "Purchased"
        case .purchasing: return "Purchasing"
        case .restored: return "Restored"
        @unknown default:
            fatalError()
        }
    }
}
