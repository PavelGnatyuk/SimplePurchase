//
//  ProductStore.swift
//
//  Protocol defining an approach to store product information.
//  The product information is retrieved from the App Store.
//
//  Created by Pavel Gnatyuk on 01/05/2017.
//
//

import StoreKit

/**
 A store of products that can be accessible via their product identifiers.
 */
protocol ProductStore {

    /// Gives the number of products in the store
    var count: Int { get }
    
    /// Assign new array of products
    mutating func assignTo(store: [SKProduct])

    /**
     Subscription.
     - Parameter identifier: the string product identifier (ex. com.app.product1). The identifier cannot be empty.
     - Return: can be nil if the product fitting to the identifier is not found.
     */
    subscript(identifier: String) -> SKProduct? { get }
}
