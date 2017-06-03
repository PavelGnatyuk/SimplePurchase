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

protocol ProductStore {
    var count: Int { get }
    
    /**
        The store is optional. It is requested from the App Store and so can be nil (theoretically). 
        But I see that this array is empty and never nil.
     */
    var store: Array<SKProduct>? { get set }
    
    subscript(identifier: String) -> SKProduct? { get }
}
