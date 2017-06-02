//
//  AppPriceConverter.swift
//
//  Make a string from the price stored in App Store product information. This price is an NSNumber object.
//  The product information contains the current locale too.
//  Example: $0.99 created from 0.99 and English US locale.
//
//  Created by Pavel Gnatyuk on 29/04/2017.
//
//

import Foundation

class AppPriceConverter: PriceConverter {
    lazy var formatter: NumberFormatter = {
        let numberFormatter                 = NumberFormatter()
        numberFormatter.formatterBehavior   = .behavior10_4
        numberFormatter.numberStyle         = .currency
        return numberFormatter
    }()
    
    func convert(_ price: NSNumber, locale: Locale) -> String {
        guard price.compare(NSDecimalNumber.zero) == .orderedDescending else {
            return ""
        }
        self.formatter.locale = locale
        guard let text = self.formatter.string(from: price) else {
            return ""
        }
        return text
    }    
}
