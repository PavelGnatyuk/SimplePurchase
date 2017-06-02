//
//  ProductRequester.swift
//
//  Allows to request the product information for one or few products defined by their identifiers.
//
//
//  Created by Pavel Gnatyuk on 29/04/2017.
//
//

import StoreKit

/**
 Request product information from the AppStore
 
 - Note: 
 ProductRequester class should conform to the NSObjectProtocol, it is required by the StoreKit.
 */
class AppProductRequester: NSObject, ProductRequester {
    
    var products: Array<SKProduct>?
    var invalidProductIdentifiers: Array<String>?
    
    fileprivate(set) var onComplete: ((Array<SKProduct>?) -> Void)?
    fileprivate(set) var productRequest: SKProductsRequest?
    
    /**
     Send request to the App Store
    */
    func request(identifiers: Set<String>, onComplete: ((Array<SKProduct>?) -> Void)?) -> Bool {
        assert(productRequest == nil, "A previous request still exists")
        assert(identifiers.count > 0, "No product identifiers")
        
        guard identifiers.count > 0 else {
            return false
        }
        
        products = nil
        invalidProductIdentifiers = nil
        productRequest = SKProductsRequest(productIdentifiers: identifiers)
        productRequest?.delegate = self
        self.onComplete = onComplete
        productRequest?.start()
        return true
    }
}

extension AppProductRequester: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard self.productRequest == request else {
            return
        }
        
        self.products = response.products
        self.invalidProductIdentifiers = response.invalidProductIdentifiers
        self.productRequest = nil
        
        self.onComplete?(self.products)
    }
 
    func request(_ request: SKRequest, didFailWithError error: Error) {
        guard self.productRequest == request else {
            return
        }
        
        self.onComplete?(nil)
        self.productRequest = nil
    }
}

