//
//  InverseAuction.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 20/03/24.
//

import Foundation

class InverseAuction: Auction {
    var startingPrice: Int
    var expiryDate: Date
    
    init(id: Int, title: String, description: String?, category: String?, sellerId: Int, urlPicture: String, isActive: Bool, isFailed: Bool, currentPrice: Double, startingPrice: Int, expiryDate: Date) {
        self.startingPrice = startingPrice
        self.expiryDate = expiryDate
        super.init(id: id, title: title, description: description, category: category, sellerId: sellerId, urlPicture: urlPicture, isActive: isActive, isFailed: isFailed, currentPrice: currentPrice)
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    
}
