//
//  PriceConvertor.swift
//
//  Make a string from the price stored in App Store product information. This price is an NSNumber object.
//  The product information contains the current locale too.
//  Example: $0.99 created from 0.99 and English US locale.
//
//  Created by Pavel Gnatyuk on 28/04/2017.
//
//

import Foundation

protocol PriceConverter {
    /// Convert a price to a localized string
    func convert(_ price: NSNumber, locale: Locale) -> String
}
