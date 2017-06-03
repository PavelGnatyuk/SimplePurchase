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
    func request(identifiers: Set<String>, onComplete: @escaping (([SKProduct], [String]) -> Void)) -> Bool {
        counter += 1
        return true
    }
}
