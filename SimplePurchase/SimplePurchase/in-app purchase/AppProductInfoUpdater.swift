//
//  AppProductInfoUpdater.swift
//
//  Update product information from the App Store only if a predefined time period has past.
//  For example, an application may check if the prices on the App Store were changed when the app
//  was in the background.
//
//
//  Created by Pavel Gnatyuk on 27/04/2017.
//
//

import Foundation

/**
 Class requesting the product information from the App Store only if a predefined
 time period has past.
 */
class AppProductInfoUpdater: ProductInfoUpdater {
    
    let purchaseController: PurchaseController
    let timeout: TimeInterval
    private(set) var lastTime: Date?
    
    init(purchaseController: PurchaseController, timeout: TimeInterval) {
        self.purchaseController = purchaseController
        self.timeout            = timeout
    }
    
    var updateNeeded: Bool {
        // If the purchase controller is not ready to request the product information we cannot continue
        // and the update is not needed.
        if !self.purchaseController.isReadyToRequest {
            return false
        }
        
        // A bit a strange case after the previous check: the product info has been requested but
        // not via this Updater instance.
        if self.lastTime == nil {
            return true
        }
        
        // We are here if the purchase manager has requested the products from the App Store
        // and so contains the prices.
        // So we need to update these products' information if a predefined timeout has past.
        //
        // `lastTime` is not nil here for sure, because it can be privaty set only from this class.
        guard let interval = self.lastTime?.timeIntervalSinceNow else {
            return true
        }
        return interval == 0 || -interval > self.timeout
    }
    
    func updateIfNeeded() -> Bool {
        if self.updateNeeded == false {
            return false
        }
        lastTime = Date()
        return self.purchaseController.requestProducts()
    }
}
