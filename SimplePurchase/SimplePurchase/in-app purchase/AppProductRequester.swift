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
    
    fileprivate(set) var onComplete: (([SKProduct], [String]) -> Void)?
    fileprivate(set) var productRequest: SKProductsRequest?
    
    /**
     Send request to the App Store
    */
    func request(identifiers: Set<String>, onComplete: @escaping (([SKProduct], [String]) -> Void)) -> Bool {
        assert(productRequest == nil, "A previous request still exists")
        guard identifiers.count > 0 else {
            assertionFailure("No identifiers to request products")
            return false
        }
        
        productRequest = SKProductsRequest(productIdentifiers: identifiers)
        if let requester = productRequest {
            requester.delegate = self
            self.onComplete = onComplete
            requester.start()
        }
        return productRequest != nil
    }
}

extension AppProductRequester: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard self.productRequest == request else {
            assertionFailure("Received a response for a wrong request")
            return
        }
        
        self.onComplete?(response.products, response.invalidProductIdentifiers)
        self.productRequest = nil
        self.onComplete = nil
    }
 
    func request(_ request: SKRequest, didFailWithError error: Error) {
        guard self.productRequest == request else {
            assertionFailure("Received a response for a wrong request")
            return
        }
        
        self.onComplete?([], [])
        self.productRequest = nil
        self.onComplete = nil
    }
}

