//
//  AppDelegate.swift
//  SimplePurchase
//
//  Created by Pavel Gnatyuk on 02/06/2017.
//  Copyright © 2017 Pavel Gnatyuk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    let productIdentifiers: Set<String> = ["com.demo.in-app.purchase.SimplePurchase.one",
                                           "com.demo.in-app.purchase.SimplePurchase.two",
                                           "com.demo.in-app.purchase.SimplePurchase.three"]
    
    lazy var purchase: PurchaseController = {
        let controller = AppPurchaseController(identifiers: self.productIdentifiers)
        controller.converter = AppPriceConverter()
        controller.observer = AppPaymentTransactionObserver()
        controller.requester = AppProductRequester()
        controller.products = AppProductStore()
        return controller
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let viewController = ViewController()
        viewController.purchases = purchase
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
}

