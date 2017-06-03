//
//  PaymentTransactionObserver.swift
//
//  Exactly as it's named: the payment transaction observer.
//
//  Created by Pavel Gnatyuk on 29/04/2017.
//
//

import StoreKit

protocol PaymentTransactionObserver: class {
    var canMakePayments: Bool { get }
    
    init(delegate: PaymentTransactionObserverDelegate?)
    
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

