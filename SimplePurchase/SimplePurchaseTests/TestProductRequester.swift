//
//  TestProductRequester.swift
//  FairyTales
//
//  Created by Pavel Gnatyuk on 27/05/2017.
//
//

import Foundation
import StoreKit

class TestProductRequester: ProductRequester {
    var counter = 0
    func request(identifiers: Set<String>, onComplete: ((Array<SKProduct>?) -> Void)?) -> Bool {
        counter += 1
        return true
    }
}
