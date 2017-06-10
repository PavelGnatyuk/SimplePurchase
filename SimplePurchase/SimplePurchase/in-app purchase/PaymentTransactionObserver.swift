//
//  PaymentTransactionObserver.swift
//
//  Exactly as it's named: the payment transaction observer.
//
//  The protocol allows to write unit-test for the purchase controller.
//
//  Created by Pavel Gnatyuk on 29/04/2017.
//
//

import StoreKit

/// Wrapper for the payment observer allowing to unit test the purchase controller.
protocol PaymentTransactionObserver: class {
    var canMakePayments: Bool { get }
    
    init(delegate: PaymentTransactionObserverDelegate?)
    
    /// The observer should be started on the app launch in order to catch the lost transactions.
    func start()
    
    /// Probably this function is never used in the real application
    func stop()
    
    /// Add payment to the payment queue
    func add(_ payment: SKPayment)
    
    /// Finish the payment transaction
    func finish(_ transaction: SKPaymentTransaction)
    
    /// Restore transactions
    func restoreTransactions()
}

@objc
protocol PaymentTransactionObserverDelegate: class {
    func onPurchased(_ transaction: SKPaymentTransaction)
    func onFailed(_ transaction: SKPaymentTransaction)
    func onRestored(_ transaction: SKPaymentTransaction)
    @objc optional func onPurchasing(_ transaction: SKPaymentTransaction)
    @objc optional func onDeferred(_ transaction: SKPaymentTransaction)
}

