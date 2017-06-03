//
//  AppPaymentTransactionObserver.swift
//
//  Payment transaction observer - actually a wrapper for SKPaymentQueue adding new payment to it
//  and handling all states of this payment in the queue.
//
//
//  Created by Pavel Gnatyuk on 29/04/2017.
//
//

import StoreKit

@objc
class AppPaymentTransactionObserver: NSObject, PaymentTransactionObserver {
    
    private(set) var active: Bool = false
    fileprivate weak var delegate: PaymentTransactionObserverDelegate?
    
    required init(delegate: PaymentTransactionObserverDelegate?) {
        self.delegate = delegate
    }
    
    deinit {
        delegate = nil
    }
    
    var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func start() {
        if active == false {
            SKPaymentQueue.default().add(self)
            active = true
        }
    }
    
    func stop() {
        SKPaymentQueue.default().remove(self)
    }
    
    func add(_ payment: SKPayment) {
        SKPaymentQueue.default().add(payment)
    }
    
    func finish(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func restoreTransactions() {
        if canMakePayments {
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }
}

extension AppPaymentTransactionObserver: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchasing:
                self.delegate?.onPurchasing?(transaction)
                
            case .purchased:
                self.delegate?.onPurchased(transaction)
                
            case .failed:
                self.delegate?.onFailed(transaction)
                
            case .restored:
                self.delegate?.onRestored(transaction)
                
            case .deferred:
                self.delegate?.onDeferred?(transaction)
            }
        }
    }
}
