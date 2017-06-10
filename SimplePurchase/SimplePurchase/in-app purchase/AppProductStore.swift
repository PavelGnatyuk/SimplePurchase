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

/**
 A store of products that can be accessible via their product identifiers.
 Currently it is a simple wrapper of an array of SKProduct objects.
 */
struct AppProductStore: ProductStore {
    /// Gives the number of products in the store
    var count: Int {
        return self.store.count
    }
    
    private var store = [SKProduct]()
    
    mutating func assignTo(store: [SKProduct]) {
        self.store = store
    }

    /**
     Subscription.
     - Parameter identifier: the string product identifier (ex. com.app.product1). The identifier cannot be empty.
     - Return: can be nil if the product fitting to the identifier is not found.
     */
    subscript(identifier: String) -> SKProduct? {
        assert(!identifier.isEmpty, "Cannot find a product for an empty identifier")
        for product in store where product.productIdentifier == identifier {
            return product
        }
        return nil
    }
}
