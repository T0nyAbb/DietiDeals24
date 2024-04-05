//
//  OfferChecker.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 29/03/24.
//

import Foundation

class OfferChecker {
    
    func checkFixedTimeOffer(currentPrice: Double, offerAmount: Double) -> Bool {
        if(offerAmount > currentPrice) {
            return true
        }
        return false
    }
    
    func checkInverseAuctionOffer(currentPrice: Double, offerAmount: Double) -> Bool {
        if(offerAmount < currentPrice) {
            return true
        }
        return false
    }
}
