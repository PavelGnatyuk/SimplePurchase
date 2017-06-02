//
//  AppProductInfoUpdater_Tests.swift
//  FairyTales
//
//  Created by Pavel Gnatyuk on 28/04/2017.
//
//

import XCTest

class AppProductInfoUpdater_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUpdaterCreation() {
        let timeout: TimeInterval = 123
        let mock = TestPurchaseController()
        let updater = AppProductInfoUpdater(purchaseController: mock, timeout: timeout)
        XCTAssertTrue(updater.timeout == timeout, "Timeout in the updater is not initialized correctly")
        XCTAssertFalse(updater.updateNeeded, "Update should be true. The Updater instance was just created.")
    }
    
    func testUpdaterFirstRequest() {
        let timeout: TimeInterval = 123
        let mock = TestPurchaseController()
        mock.identifiers = ["1"] // Dummy product identifier
        mock.isReadyToRequest = true
        let updater = AppProductInfoUpdater(purchaseController: mock, timeout: timeout)
        
        XCTAssertTrue(updater.updateNeeded, "Updater gives a wrong result. The product info has not been requested")
        XCTAssertTrue(updater.lastTime == nil, "Last time is supposed to be nil for this case")
    }
    
    func testUpdaterRequest() {
        let timeout: TimeInterval = 123
        let mock = TestPurchaseController()
        mock.identifiers = ["1"] // Dummy product identifier
        mock.isReadyToRequest = true
        let updater = AppProductInfoUpdater(purchaseController: mock, timeout: timeout)
        
        let requested = updater.updateIfNeeded()
        XCTAssertTrue(requested, "Product info was not requested. But it should. The updater was just created.")
        XCTAssert(mock.requestCounter == 1, "Product info should be requested one time")
        XCTAssertTrue(updater.lastTime != nil, "Last time cannot be nil after the request")
    }
    
    func testUpdaterRequestTimeOut() {
        let timeout: TimeInterval = 123
        let mock = TestPurchaseController()
        mock.identifiers = ["1"] // Dummy product identifier
        mock.isReadyToRequest = true
        let updater = AppProductInfoUpdater(purchaseController: mock, timeout: timeout)
        
        var requested = updater.updateIfNeeded()
        XCTAssertTrue(requested, "Product info was not requested. But it should. The updater was just created.")
        XCTAssert(mock.requestCounter == 1, "Product info should be requested one time")
        XCTAssertTrue(updater.lastTime != nil, "Last time cannot be nil after the request")
        
        mock.requestCounter = 0
        let stamp = updater.lastTime!
        
        requested = updater.updateIfNeeded()
        XCTAssertFalse(requested, "Product info was requested. But it should not")

        XCTAssert(mock.requestCounter == 0, "Product info should not be requested")
        XCTAssertEqual(stamp, updater.lastTime!, "Last time is not supposed to change here")
    }

    func testUpdaterRequestAfterTimeOut() {
        let timeout: TimeInterval = 1.5
        let mock = TestPurchaseController()
        mock.identifiers = ["1"] // Dummy product identifier
        mock.isReadyToRequest = true
        let updater = AppProductInfoUpdater(purchaseController: mock, timeout: timeout)
        
        var requested = updater.updateIfNeeded()
        XCTAssertTrue(requested, "Product info was not requested. But it should. The updater was just created.")
        XCTAssert(mock.requestCounter == 1, "Product info should be requested one time")
        XCTAssertTrue(updater.lastTime != nil, "Last time cannot be nil after the request")
        
        mock.requestCounter = 0
        mock.isReadyToRequest = true
        let stamp = updater.lastTime!

        let expecting = expectation(description: "Wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            requested = updater.updateIfNeeded()
            XCTAssertTrue(requested, "Product info was requested. But it should not")
            
            XCTAssert(mock.requestCounter == 1, "Product info should be requested")
            XCTAssertNotEqual(stamp, updater.lastTime!, "Last time is not supposed to change here")
            expecting.fulfill()
        }
        
        wait(for: [expecting], timeout: 1200)
    }
}
