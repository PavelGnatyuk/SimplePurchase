//
//  AppPurchaseControllerTests.swift
//  SimplePurchase
//
//  Created by Pavel Gnatyuk on 02/06/2017.
//  Copyright © 2017 Pavel Gnatyuk. All rights reserved.
//

import XCTest

class AppPurchaseControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJustCreatedController() {
        let controller = AppPurchaseController(identifiers: ["1"])
        XCTAssertFalse(controller.isReadyToRequest, "The controller cannot be ready. There is no product requester injected")
        XCTAssertFalse(controller.isReadyToPurchase, "The controller cannot be ready to purchase")
        XCTAssertFalse(controller.containsProducts, "The controller cannot contain products.")
    }
    
    func testIsReadyToRequest() {
        let controller = AppPurchaseController(identifiers: ["1"])
        controller.requester = TestProductRequester()
        XCTAssertTrue(controller.isReadyToRequest, "The controller is not ready to request products.")
    }
    
    /**
     In the following test the controller is not ready because the product info was never requested from
     the App Store.
     */
    func testIsNotReadyToPurchase() {
        let controller = AppPurchaseController(identifiers: ["1"])
        controller.observer = TestPaymentTransactionObserver(delegate: controller)
        XCTAssertFalse(controller.isReadyToPurchase, "The controller is not ready to purchase")
    }
    
    func testIsReadyToPurchase() {
        let controller = AppPurchaseController(identifiers: ["1"])
        controller.observer = TestPaymentTransactionObserver(delegate: controller)
        controller.products = TestProductStore()
        XCTAssertTrue(controller.isReadyToPurchase, "The controller is not ready to purchase")
    }
    
    func testContainsProducts() {
        let controller = AppPurchaseController(identifiers: ["1"])
        controller.products = TestProductStore()
        XCTAssertTrue(controller.containsProducts, "No products")
    }
    
    func testDoesNotContainProducts() {
        let controller = AppPurchaseController(identifiers: ["1"])
        let store = TestProductStore()
        store.count = 0
        controller.products = store
        XCTAssertFalse(controller.containsProducts, "Contains products")
    }
    
    func testStart() {
        let controller = AppPurchaseController(identifiers: ["1"])
        let observer = TestPaymentTransactionObserver(delegate: controller)
        controller.observer = observer
        controller.start()
        XCTAssertTrue(observer.hasStarted, "Failed to start observer")
    }
    
    func testRestore() {
        let controller = AppPurchaseController(identifiers: ["1"])
        let observer = TestPaymentTransactionObserver(delegate: controller)
        controller.observer = observer
        controller.restore()
        XCTAssertTrue(observer.hasRestored, "Failed to restore purchases")
    }
    
    func testRequestProducts() {
        let controller = AppPurchaseController(identifiers: ["1"])
        let requester = TestProductRequester()
        controller.requester = requester
        let requested = controller.requestProducts()
        XCTAssertTrue(requested, "Failed to request")
        XCTAssertTrue(requester.counter == 1, "Request should be called 1 time")
    }
    
    func testPrice() {
        let controller = AppPurchaseController(identifiers: ["1"])
        let converter = TestPriceConverter()
        controller.products = TestProductStore()
        controller.converter = converter
        let price = controller.price(identifier: "1")
        XCTAssertEqual(price, "The price", "The price converter was not called")
    }
    
    func testPriceReal() {
        let controller = AppPurchaseController(identifiers: ["1"])
        let converter = AppPriceConverter()
        controller.products = TestProductStore()
        controller.converter = converter
        let price = controller.price(identifier: "1")
        XCTAssertEqual(price, "$1.23", "The price converter was not called")
    }
    
    func testBuy() {
        let controller = AppPurchaseController(identifiers: ["1"])
        controller.products = TestProductStore()
        let observer = TestPaymentTransactionObserver(delegate: controller)
        controller.observer = observer
        
        let purchaseSent = controller.buy(identifier: "1")
        XCTAssertTrue(purchaseSent, "Purchase failed")
        XCTAssertTrue(observer.hasAdded, "Payment transaction was not added")
    }
    
}
