//
//  ProductRequester.swift
//  FairyTales
//
//  Created by Pavel Gnatyuk on 26/05/2017.
//
//

import StoreKit

protocol ProductRequester {
    func request(identifiers: Set<String>, onComplete: ((Array<SKProduct>?) -> Void)?) -> Bool
}
