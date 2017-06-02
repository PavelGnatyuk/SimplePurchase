//
//  PaymentTransactionObserver.swift
//
//  Created by Pavel Gnatyuk on 29/04/2017.
//
//

import StoreKit

protocol PaymentTransactionObserver: class {
    var canMakePayments: Bool { get }
    var delegate: PaymentTransactionObserverDelegate? { get set }
        
    func start()
    func stop()
    
    func add(_ payment: SKPayment)
    func finish(_ transaction: SKPaymentTransaction)
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

