//
//  AppProductStoreTests.swift
//  FairyTales
//
//  Created by Pavel Gnatyuk on 03/06/2017.
//
//

import XCTest
import StoreKit

class AppProductStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmptyStore() {
        let store = AppProductStore()
        XCTAssertNotNil(store, "Failed to create the store")
        XCTAssertTrue(store.count == 0, "Just created store should be empty")
        XCTAssertNil(store["identifier"], "Just created store cannot contain any product")
    }
    
    func testSubscriptWithOne() {
        let identifier = "identifier"
        var store = AppProductStore()
        let product = SKProduct(identifier: identifier, price: "1.23", priceLocale: Locale(identifier: "en_US"))
        store.assignTo(store: [product])
        XCTAssertNotNil(store[identifier], "Failed to find the product")
    }

    func testSubscriptWithMany() {
        let max_count = 1000
        let identifier = "identifier"
        var store = AppProductStore()
        var count = 0
        var data = [SKProduct]()
        var prices = [String]()
        while count < max_count {
            let productIdentifier = "\(identifier)_\(count)"
            let price = "\(Double(count) + 0.99)"
            let product = SKProduct(identifier: productIdentifier, price: price, priceLocale: Locale(identifier: "en_US"))
            data.append(product)
            prices.append(price)
            count += 1
        }
        store.assignTo(store: data)
        XCTAssertEqual(store.count, max_count)
        
        count = 0
        while count < max_count {
            let productIdentifier = "\(identifier)_\(count)"
            let product = store[productIdentifier]
            XCTAssertNotNil(product, "Failed to retrieve product with identifier")
            if let retrieved = product {
                XCTAssertEqual("\(retrieved.price)", prices[count])
            }
            count += 1
        }
    }
}
