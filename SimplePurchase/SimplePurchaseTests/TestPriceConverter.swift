//
//  TestPriceConverter.swift
//  FairyTales
//
//  Created by Pavel Gnatyuk on 27/05/2017.
//
//

import Foundation

class TestPriceConverter: PriceConverter {
    func convert(_ price: NSNumber, locale: Locale) -> String {
        return "The price"
    }
}
