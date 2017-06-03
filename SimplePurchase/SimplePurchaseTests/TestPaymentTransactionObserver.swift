//
//  TestPaymentTransactionObserver.swift
//  FairyTales
//
//  Created by Pavel Gnatyuk on 27/05/2017.
//
//

import Foundation
import StoreKit

class TestPaymentTransactionObserver: PaymentTransactionObserver {
    var canMakePayments: Bool = true
    weak var delegate: PaymentTransactionObserverDelegate?
    
    var hasStarted: Bool = false
    var hasStopped: Bool = false
    var hasAdded: Bool = false
    var hasFinished: Bool = false
    var hasRestored: Bool = false
    
    required init(delegate: PaymentTransactionObserverDelegate?) {
        self.delegate = delegate
    }
    
    func start() {
        hasStarted = true
    }
    
    func stop() {
        hasStopped = true
    }
    
    func add(_ payment: SKPayment) {
        hasAdded = true
    }
    
    func finish(_ transaction: SKPaymentTransaction) {
        hasFinished = true
    }
    
    func restoreTransactions() {
        hasRestored = true
    }
}
