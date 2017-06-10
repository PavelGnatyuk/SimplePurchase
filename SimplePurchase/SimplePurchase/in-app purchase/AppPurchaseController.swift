//
//  AppPurchaseController.swift
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
//
//  Note:
//  On the simulator the purchase does not happen by intention.
//
//  Created by Pavel Gnatyuk on 29/04/2017.
//
//

import StoreKit

@objc
class AppPurchaseController: NSObject, PurchaseController {
    
    /// Initial set of product identifiers for the controller works with.
    /// It is a constant, making it variable will cause a lot of problems to worry about.
    let identifiers: Set<String>
    
    /// Price converter: convert number and locale to a string
    var converter: PriceConverter?
    
    /// Payment transaction observer
    var observer: PaymentTransactionObserver?
    
    /// Store of the products: product information retrieved from the App Store of for all products
    /// (defined by the initial set of the identifiers)
    var products: ProductStore?
    
    /// Function that will be called in the end of the buying procedure or in the end of the
    /// restore purchases process (for each product).
    var onComplete: (([String: String])->Void)?
    
    /// Request product information from the App Store
    var requester: ProductRequester?
    
    /// Flag that a request was sent and no response has been received yet.
    var requestSent: Bool = false

    /// The property is `true` when the instance is ready to request the product information:
    /// - the instance was initialized correctly with a non-empty set of identifiers.
    /// - the requester is not nil
    var isReadyToRequest: Bool {
        return identifiers.count > 0 && requester != nil
    }

    /// The property is `true` when the instance is ready to perform an in-app purchase operation:
    /// - the product information has been retrieved from the App Store
    /// - the payment queue observer is not nil.
    var isReadyToPurchase: Bool {
        guard let info = products else {
            return false
        }
        return info.count > 0 && observer != nil
    }
    
    /// The product information has been retrieved successfully.
    var containsProducts: Bool {
        guard let info = products else {
            return false
        }
        return info.count > 0
    }
    
    required init(identifiers: Set<String>) {
        precondition(identifiers.count > 0, "No identifiers and so nothing to do.")
        self.identifiers = identifiers
    }
    
    // MARK: - Request products
    
    func requestProducts() -> Bool {
        guard requestSent == false else {
            assertionFailure("The previous request is still alive. No need to send one more.")
            return false
        }
        
        guard let checkedRequester = requester else {
            assertionFailure("The requester was not set")
            return false
        }
        
        // There is an assert in the ProductRequester initializer about the identifiers parameter.
        requestSent = checkedRequester.request(identifiers: identifiers) { [weak self] receivedProducts, invalid in
            if let controller = self {
                controller.products?.assignTo(store: receivedProducts)
                controller.requestSent = false
            }
        }
        return requestSent
    }
    
    // MARK: - Price converter
    
    func price(identifier: String) -> String {
        guard let priceConverter = converter else {
            assertionFailure("Price converter is nil")
            return ""
        }

        guard !identifier.isEmpty else {
            assertionFailure("The identifier is required")
            return ""
        }

        guard let store = products else {
            assertionFailure("The products should be requested first. No price available")
            return ""
        }
        
        guard store.count > 0 else {
            assertionFailure("The products should be requested first. No price available")
            return ""
        }

        guard let product = store[identifier] else {
            assertionFailure("Product with \(identifier) is not found")
            return ""
        }
        
        return priceConverter.convert(product.price, locale: product.priceLocale)
    }
    
    // MARK: - Purchase
    
    /**
     Perform the in-app purchasing.
     - Parameter identifier: the string product identifier (ex. com.app.product1)
     - Return: `Boolean` value which is `true` if the payment was successfully added to the transaction queue.
     Note:
     The payment will not be added to the payment queue under the simulator. The callback closure will be called 
     immediatelly.
    */
    func buy(identifier: String) -> Bool {
        assert(!identifier.isEmpty, "Empty identifier")
        assert(products != nil, "Product store is nil")
        //assert((products?.count)! > 0, "No products")
        assert(observer != nil, "Transaction observer is nil")
        
        guard !identifier.isEmpty, let transactions = observer, let product = products?[identifier] else {
            return false
        }
        
        // The real device and the real purchase.
        let payment = SKPayment(product: product)
        transactions.add(payment)
        return true
    }
    
    func start() {
        observer?.start()
    }
    
    func restore() {
        observer?.restoreTransactions()
    }
}

extension AppPurchaseController: PaymentTransactionObserverDelegate {
    /**
     The function bellow is called when the payment transaction completed successfully.
     In this function the product identifier taken from the succefull transaction is saved in a local store of
     already bought product identifiers. Than the transaction is finished.
     
     - Note:
     Let's re-consider it. For example, let's finish the transaction after downloading the product.
    */
    func onPurchased(_ transaction: SKPaymentTransaction) {
        let identifier = transaction.payment.productIdentifier
        self.finish(identifier: identifier, transaction: transaction)
    }
    
    /**
     The transaction failed. The user could cancel the purchase operation.
     */
    func onFailed(_ transaction: SKPaymentTransaction) {
        if let error = transaction.error as? SKError, error.code == SKError.paymentCancelled {
            self.onComplete?([PurchaseControllerConsts.kResponseAttributeIdentifier: transaction.payment.productIdentifier,
                              PurchaseControllerConsts.kResponseAttributeSuccess: "NO",
                              PurchaseControllerConsts.kResponseAttributeError: error.localizedDescription])
        }
        self.observer?.finish(transaction)
    }
    
    /**
     Restore transaction operation succeeded
    */
    func onRestored(_ transaction: SKPaymentTransaction) {
        guard let identifier = transaction.original?.payment.productIdentifier else {
            return
        }
        self.finish(identifier: identifier, transaction: transaction)
    }
    
    /**
     Finish the payment transaction and call the complete callback.
     */
    private func finish(identifier: String, transaction: SKPaymentTransaction) {
        self.observer?.finish(transaction)
        self.onComplete?([PurchaseControllerConsts.kResponseAttributeIdentifier: identifier,
                          PurchaseControllerConsts.kResponseAttributeSuccess: "YES"])
    }
}
