//
//  ProductInfoUpdater.swift
//
//  Created by Pavel Gnatyuk on 27/04/2017.
//
//

import Foundation

/*
 Update product info from the AppStore in order to keep the actual prices
 */
protocol ProductInfoUpdater {
    /*
     Detect if an update if needed now.
    */
    var updateNeeded: Bool { get }
    
    /*
     Return value `true` means that a request was sent and `false` that there is no need to update now.
    */
    func updateIfNeeded() -> Bool
}
