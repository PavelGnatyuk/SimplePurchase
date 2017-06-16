//
//  TestPurchaseController.swift
//  FairyTales
//
//  Created by Pavel Gnatyuk on 26/05/2017.
//
//

import Foundation

class TestPurchaseController: PurchaseController {
    var isReadyToRequest = false
    var isReadyToPurchase = false
    var containsProducts = false
    
    var identifiers = Set<String>()
    
    var requestCounter: Int = 0
    
    required init(identifiers: Set<String>) {
        self.identifiers = identifiers
    }
    
    convenience init() {
        self.init(identifiers: Set<String>())
    }
    
    var onComplete: ((String, Bool, String) -> Void)?
    
    func start() {
    }
    
    func requestProducts() -> Bool {
        requestCounter += 1
        return true
    }
    
    func price(identifier: String) -> String {
        return ""
    }
    
    func buy(identifier: String) -> Bool {
        return false
    }
    
    func restore() {
    }
}
