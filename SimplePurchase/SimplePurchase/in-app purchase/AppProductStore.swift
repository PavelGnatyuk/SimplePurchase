//
//  AppProductStore.swift
//
//  Place to store the product information
//
//
//  Created by Pavel Gnatyuk on 01/05/2017.
//
//

import StoreKit

struct AppProductStore: ProductStore {
    var count: Int {
        return self.store.count
    }
    
    private var store = [SKProduct]()
    
    mutating func assignTo(store: [SKProduct]) {
        self.store = store
    }
    
    subscript(identifier: String) -> SKProduct? {
        precondition(!identifier.isEmpty, "Cannot find a product for an empty identifier")
        for product in store where product.productIdentifier == identifier {
            return product
        }
        return nil
    }
}
