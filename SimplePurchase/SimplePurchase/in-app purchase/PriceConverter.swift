//
//  PriceConvertor.swift
//
//  Created by Pavel Gnatyuk on 28/04/2017.
//
//

import Foundation

protocol PriceConverter {
    func convert(_ price: NSNumber, locale: Locale) -> String
}
