//
//  ProductRequester.swift
//
//  Allows to request the product information for one or few products defined by their identifiers.
//  The class is a wrapper for SKProductsRequest. It does not make sense to unit test it.
//
//  The class allows to write unit-test for the purchase controller.
//
//  Created by Pavel Gnatyuk on 29/04/2017.
//
//

import StoreKit

/**
 Request product information from the AppStore.
 The class allows to write unit-test for the purchase controller.
 
 - Note: 
 ProductRequester class should conform to the NSObjectProtocol, it is required by the StoreKit.
 */
class AppProductRequester: NSObject, ProductRequester {
    
    fileprivate(set) var onComplete: (([SKProduct], [String]) -> Void)?
    fileprivate(set) var productRequest: SKProductsRequest?
    
    /**
     Send request to the App Store
     - Parameter identifiers: Set<String> set of string product identifiers.
     - Parameter onComplete: escaping closure that will be called after the App Store response.
     - Return: Bool value meaning that the request was sent
     - Note: The class does not allow to sent two requests simulteniously.
    */
    func request(identifiers: Set<String>, onComplete: @escaping (([SKProduct], [String]) -> Void)) -> Bool {
        precondition(productRequest == nil, "A previous request still exists")
        guard identifiers.count > 0 else {
            assertionFailure("No identifiers to request products")
            return false
        }
        
        if productRequest != nil {
            assertionFailure("One request has been sent")
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

