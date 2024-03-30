//
//  Offer.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 29/03/24.
//

import Foundation

struct Offer: Codable {
    let offerId: Int?
    var bidderId: Int
    var bidAmount: Double
    var auctionId: Int
    
    init(offerId: Int?, bidderId: Int, bidAmount: Double, auctionId: Int) {
        self.offerId = offerId
        self.bidderId = bidderId
        self.bidAmount = bidAmount
        self.auctionId = auctionId
    }
}
