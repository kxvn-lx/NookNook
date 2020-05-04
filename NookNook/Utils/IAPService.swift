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
    
    enum IAPProduct: String {
        case RemoveAds = "com.kevinlaminto.NookNook.RemoveAds1"
    }
    
    private override init() { }
    static let shared = IAPService()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    /// Get all the IN-App products
    func getProducts() {
        let products: Set = [IAPProduct.RemoveAds.rawValue]
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
    
}


extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
            print(product.productIdentifier)
        }
    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing: break
            case .failed:
                queue.finishTransaction(transaction)
                Taptic.errorTaptic()
            case .purchased, .restored:
                queue.finishTransaction(transaction)
                Taptic.successTaptic()
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
