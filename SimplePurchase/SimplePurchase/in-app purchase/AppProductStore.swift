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
        return self.store?.count ?? 0
    }
    
    var store: Array<SKProduct>?
    
    subscript(identifier: String) -> SKProduct? {
        guard let array = store, !identifier.isEmpty else {
            return nil
        }
        for product in array where product.productIdentifier == identifier {
            return product
        }
        return nil
    }
}
