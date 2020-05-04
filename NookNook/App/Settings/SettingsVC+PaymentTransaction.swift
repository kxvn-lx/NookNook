//
//  SettingsVC+PaymentTransaction.swift
//  NookNook
//
//  Created by Kevin Laminto on 4/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import StoreKit
import UIKit

extension SettingsTableViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        transactions.forEach({
            if $0.transactionState == .purchased {
                print("Transaction successful.")
            }
            else if $0.transactionState == .failed {
                print("Transaction failed.")
            }
        })
    }
    
}
