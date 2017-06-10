//
//  ProductRequester.swift
//  FairyTales
//
//  Protocol defining the requesting the product information from the App Store.
//  The class allows to write unit-test for the purchase controller.
//
//  Created by Pavel Gnatyuk on 26/05/2017.
//
//

import StoreKit

protocol ProductRequester {
    /**
     Send request retrieving the product information to the App Store
     */
    func request(identifiers: Set<String>, onComplete: @escaping (([SKProduct], [String]) -> Void)) -> Bool
}
