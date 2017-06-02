//
//  AppPriceConverter_Tests.swift
//  FairyTales
//
//  Created by Pavel Gnatyuk on 29/04/2017.
//
//

import XCTest

class AppPriceConverter_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimple0_99_US() {
        let locale = Locale(identifier: "en_US")
        let number = NSDecimalNumber(string: "0.99", locale: locale)
        let price = AppPriceConverter().convert(number, locale: locale)
        XCTAssertEqual(price, "$0.99", "0.99$ not converted correctly")
    }

    func testSimple3_90_NIS() {
        let etalon = "3.90 ₪"
        let locale = Locale(identifier: "he_IL")
        let number = NSDecimalNumber(string: "3.90", locale: locale)
        let price = AppPriceConverter().convert(number, locale: locale)
        XCTAssertEqual(price, etalon, "\(etalon) not converted correctly")
    }

    func testSimple129_RU() {
        let etalon = "129,00 ₽"
        let locale = Locale(identifier: "ru_RU")
        let number = NSDecimalNumber(string: "129.00", locale: locale)
        let price = AppPriceConverter().convert(number, locale: locale)
        XCTAssertEqual(price, etalon, "\(etalon) not converted correctly")
    }
    
    func testFewLocales() {
        let localeUS = Locale(identifier: "en_US")
        let converter = AppPriceConverter()
        let data = ["en_US": "$0.99", "ru_RU": "0,99 ₽", "he_IL": "0.99 ₪", "en_GB": "£0.99"]
        data.forEach { (name, etalon) in
            let locale = Locale(identifier: name)
            let amount = NSDecimalNumber(string: "0.99", locale: localeUS)
            let price = converter.convert(amount, locale: locale)
            XCTAssertEqual(price, etalon, "Wrong converting of \(etalon)")
        }
    }
    
    func testZeroPrice() {
        let converter = AppPriceConverter()
        let price = converter.convert(NSDecimalNumber.zero, locale: Locale(identifier: "en_US"))
        XCTAssertEqual(price, "", "Zero price converted not as it is requested")
    }    
}
