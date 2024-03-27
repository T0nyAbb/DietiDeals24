//
//  DescendingPriceAuction.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 20/03/24.
//

import Foundation

class DescendingPriceAuction: Auction {
    var startingPrice: Int
    var startingDate: Date
    var timer: Int
    var timerAmount: Int
    var reduction: Int
    var minimumPrice: Int
    
    init(id: Int, title: String, description: String?, category: String?, sellerId: Int, urlPicture: String, isActive: Bool, isFailed: Bool, currentPrice: Double, startingPrice: Int, startingDate: Date, timer: Int, timerAmount: Int, reduction: Int, minimumPrice: Int) {
        self.startingPrice = startingPrice
        self.startingDate = startingDate
        self.timer = timer
        self.timerAmount = timerAmount
        self.reduction = reduction
        self.minimumPrice = minimumPrice
        super.init(id: id, title: title, description: description, category: category, sellerId: sellerId, urlPicture: urlPicture, isActive: isActive, isFailed: isFailed, currentPrice: currentPrice)
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
