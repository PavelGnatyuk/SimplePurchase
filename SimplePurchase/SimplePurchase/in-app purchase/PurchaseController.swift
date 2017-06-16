//
//  PurchaseController.swift
//
//  Requirements:
//  1. Contain a set of product identifiers (in order to get the products from the App Store).
//  2. Retrieve product information from the App store (In order to get product prices and buy the products).
//  3. Buy a product.
//  4. Restore already purchased products.
//  5. If a purchase process was interrupted (by a crash?), the app should continue with the in-app purchase after re-start.
//
//
//  References:
//
//  1. Guides and Sample Code. In-App Purchase Programming Guide
//      https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Introduction.html#//apple_ref/doc/uid/TP40008267
//
//  2. API Reference. StoreKit.
//      https://developer.apple.com/reference/storekit
//
//  3. WWDC 2016. Session 702
//      https://developer.apple.com/videos/play/wwdc2016/702/
//
//  4. Looks like a good resource to be used as a references:
//      [SwiftyStoreKit](https://github.com/bizz84/SwiftyStoreKit)
//      This project contains the receipt verification code.
//
//  5. Technical Note TN2387. In-App Purchase Best Practices
//      https://developer.apple.com/library/content/technotes/tn2387/_index.html#//apple_ref/doc/uid/DTS40014795
//
//  6. Five In-App Purchase Mistakes to Avoid
//      https://cocoacasts.com/five-in-app-purchase-mistakes-to-avoid/
//
//  Created by Pavel Gnatyuk on 29/04/2017.
//
//

import StoreKit

@objc
protocol PurchaseController {
    /**
     Check if the controller is ready to request product information from the App Store.
     -  Note:
     This controller is initialized with the set of product identifiers and the product requester
     is injected to the instance.
     */
    var isReadyToRequest: Bool { get }

    /**
     Check if the controller is ready to make purchase from the App Store
     -  Note:
     This controller is initialized with the set of product identifiers and the product info has been requested
     from the App Store. Also the payment transaction observer is injected to the instance.
     */
    var isReadyToPurchase: Bool { get }

    /**
     Check if the controller contains product information for the initial set of the product identifiers.
     already retrieved the product information for the product identifiers from the App Store.
     */
    var containsProducts: Bool { get }
    
    /**
     - Paramer: Initial set of product identifiers for the controller works with.
    */
    init(identifiers: Set<String>)
    
    /**
     Function that will be called in the end of the buying procedure or in the end of the
     restore purchases process (for each product).
     */
    var onComplete: ((_ identifier: String, _ purchased: Bool, _ error: String) -> Void)? { get set }

    /**
     Start payment transaction observer. It allows to continue with an interrupted purchase.
     */
    func start()
    
    /**
     Request informations about all products from the App Store. Main goal is to check that the product with
     a product identifier exists and what is its price.
     - Note:
     The prices do not change each day, so let request product info not too often, when the app starts up or
     comeback from the background. Later on, when the app needs to show the product info, it will take
     the already requested and received info.
     */
    func requestProducts() -> Bool
    
    /**
     Give a price (as a string) of a product defined by its identifier.
     - Parameter identifier: the string product identifier (ex. com.app.product1)
     - Return: the product price as a string. Empty string if a product was not found ot its product information
     has not been requested from the App Store.
     */
    func price(identifier: String) -> String
    
    /**
     Purchase a product defined by its identifier.
     - Parameter identifier: the string product identifier (ex. com.app.product1)
     - Return: `Boolean` value which is `true` if the payment was successfully added to the transaction queue.
     - Note:
     The product information for that identifier should be requested before the purchase.
     */
    func buy(identifier: String) -> Bool
    
    /**
     Restore payment transactions
     */
    func restore()
}
