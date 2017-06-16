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
     Send request to the App Store to retrieve the product information
     - Parameter identifiers: Set<String> set of string product identifiers.
     - Parameter onComplete: escaping closure that will be called after the App Store response.
     - Return: Bool value meaning that the request was sent
     */
    func request(identifiers: Set<String>, onComplete: @escaping (([SKProduct], [String]) -> Void)) -> Bool
}
