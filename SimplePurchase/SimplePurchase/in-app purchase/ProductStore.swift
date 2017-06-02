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
    var store: Array<SKProduct>? { get set }
    subscript(identifier: String) -> SKProduct? { get }
}