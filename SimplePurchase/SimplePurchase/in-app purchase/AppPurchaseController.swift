//
//  AppPurchaseController.swift
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
    var onComplete: ((String, Bool, String) -> Void)?
    
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
     The transaction failed. The user could cancel the purchase operation and in this case the error text
     should be empty (Apple gives "Could not connect to iTunes" or something like that).
     */
    func onFailed(_ transaction: SKPaymentTransaction) {
        // Let's finish the transaction anyway.
        self.observer?.finish(transaction)
        
        // Detect the error description
        var errorDescription = ""
        if let error = transaction.error as? SKError, error.code != SKError.paymentCancelled {
            errorDescription = error.localizedDescription
        }
        
        self.onComplete?(transaction.payment.productIdentifier, false, errorDescription)
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
        self.onComplete?(identifier, true, "")
        self.observer?.finish(transaction)
    }
}
