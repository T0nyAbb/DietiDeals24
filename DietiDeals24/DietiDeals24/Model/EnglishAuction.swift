//
//  EnglishAuction.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 20/03/24.
//

import Foundation

class EnglishAuction: Auction {
    var startingPrice: Int
    var startingDate: Date
    var timer: Int
    var timerAmount: Int
    var rise: Int
    
    init(id: Int, title: String, description: String?, category: String?, sellerId: Int, urlPicture: String, isActive: Bool, isFailed: Bool, currentPrice: Double, startingPrice: Int, startingDate: Date, timer: Int, timerAmount: Int, rise: Int) {
        self.startingPrice = startingPrice
        self.startingDate = startingDate
        self.timer = timer
        self.timerAmount = timerAmount
        self.rise = rise
        super.init(id: id, title: title, description: description, category: category, sellerId: sellerId, urlPicture: urlPicture, isActive: isActive, isFailed: isFailed, currentPrice: currentPrice)
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
