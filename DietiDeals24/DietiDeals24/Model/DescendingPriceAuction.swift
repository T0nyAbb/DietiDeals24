//
//  DescendingPriceAuction.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 20/03/24.
//

import Foundation

class DescendingPriceAuction: Auction, Identifiable {
    var startingPrice: Int
    var startingDate: Date
    var timer: Int?
    var timerAmount: Int
    var reduction: Int
    var minimumPrice: Int
    
    init(id: Int?, title: String, description: String?, category: String?, sellerId: Int, urlPicture: String?, active: Bool?, failed: Bool?, currentPrice: Double?, startingPrice: Int, startingDate: Date, timer: Int?, timerAmount: Int, reduction: Int, minimumPrice: Int) {
        self.startingPrice = startingPrice
        self.startingDate = startingDate
        self.timer = timer
        self.timerAmount = timerAmount
        self.reduction = reduction
        self.minimumPrice = minimumPrice
        super.init(id: id, title: title, description: description, category: category, sellerId: sellerId, urlPicture: urlPicture, active: active, failed: failed, currentPrice: currentPrice ?? 0)
    }
    
    enum DPACodingKeys: String, CodingKey {
        case startingPrice
        case startingDate
        case timer
        case timerAmount
        case reduction
        case minimumPrice
        case expiryDate
        case id
        case title
        case description
        case category
        case sellerId
        case urlPicture
        case active
        case failed
        case currentPrice
    }
    
    override func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: DPACodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(startingPrice, forKey: .startingPrice)
        try container.encode(startingDate, forKey: .startingDate)
        try container.encodeIfPresent(timer, forKey: .timer)
        try container.encode(timerAmount, forKey: .timerAmount)
        try container.encode(reduction, forKey: .reduction)
        try container.encode(minimumPrice, forKey: .minimumPrice)
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: DPACodingKeys.self)
        startingPrice = try values.decode(Int.self, forKey: .startingPrice)
        startingDate = try values.decode(Date.self, forKey: .startingDate)
        timer = try values.decodeIfPresent(Int.self, forKey: .timer)
        timerAmount = try values.decode(Int.self, forKey: .timerAmount)
        reduction = try values.decode(Int.self, forKey: .reduction)
        minimumPrice = try values.decode(Int.self, forKey: .minimumPrice)
        try super.init(from: decoder)
    }
}
