## SimplePurchase
Demo of a simple in-app purchase controller.
The controller performs only basic functions:
1. Request product information from the App Store
2. Buy a product
3. Restore purchases.

#### References:
1. [Guides and Sample Code. In-App Purchase Programming Guide](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Introduction.html#//apple_ref/doc/uid/TP40008267)      
2. [API Reference. StoreKit.](https://developer.apple.com/reference/storekit)
3. [WWDC 2016. Session 702](https://developer.apple.com/videos/play/wwdc2016/702/)
4. [Technical Note TN2387. In-App Purchase Best Practices](https://developer.apple.com/library/content/technotes/tn2387/_index.html#//apple_ref/doc/uid/DTS40014795)

### How to use
I'd add an instance of `AppPurchaseController` to the application delegate (app/flow coordinator):
```swift
lazy var purchase: PurchaseController = {
    let controller = AppPurchaseController(identifiers: self.productIdentifiers)
    controller.converter = AppPriceConverter()
    controller.observer = AppPaymentTransactionObserver()
    controller.requester = AppProductRequester()
    controller.products = AppProductStore()
    return controller
}()
```

It is recommended to request the product information when the app starts up (becomes active? enter to the foreground). For example, so:
```swift
- (void)applicationDidBecomeActive:(UIApplication *)application {
    _ = self.productInfoUpdater.updateIfNeeded()
}
```
where `` is lazy property:
```swift
lazy var productInfoUpdater: ProductInfoUpdater = {
    let updater = AppProductInfoUpdater(purchaseController: self.purchase,
                                        timeout: Timeouts.productInfoUpdateTimeInterval)
    return updater
}()
```

The source code if in Swift and is fully testable.
Hopefully, I will add more unit tests and more complicated features later.





