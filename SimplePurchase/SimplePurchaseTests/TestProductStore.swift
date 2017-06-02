//
//  TestProductStore.swift
//  FairyTales
//
//  Created by Pavel Gnatyuk on 27/05/2017.
//
//

import StoreKit

public extension SKProduct {
    
    convenience init(identifier: String, price: String, priceLocale: Locale) {
        self.init()
        self.setValue(identifier, forKey: "productIdentifier")
        self.setValue(NSDecimalNumber(string: price), forKey: "price")
        self.setValue(priceLocale, forKey: "priceLocale")
    }
}

class TestProductStore: ProductStore {
    var count: Int = 1
    var store: Array<SKProduct>?
    
    subscript(identifier: String) -> SKProduct? {
        return SKProduct(identifier: "com.test.one", price: "1.23", priceLocale: Locale(identifier: "en_US"))
    }
}
