//
//  EnglishAuction.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 20/03/24.
//

import Foundation

class EnglishAuction: Auction, Identifiable {
    var startingPrice: Int
    var startingDate: Date
    var timer: Int
    var timerAmount: Int
    var rise: Int
    
    init(id: Int?, title: String, description: String?, category: String?, sellerId: Int, urlPicture: String?, active: Bool?, failed: Bool?, currentPrice: Double?, startingPrice: Int, startingDate: Date, timer: Int, timerAmount: Int, rise: Int) {
        self.startingPrice = startingPrice
        self.startingDate = startingDate
        self.timer = timer
        self.timerAmount = timerAmount
        self.rise = rise
        super.init(id: id, title: title, description: description, category: category, sellerId: sellerId, urlPicture: urlPicture, active: active, failed: failed, currentPrice: currentPrice ?? 0)
    }
    
    enum EACodingKeys: String, CodingKey {
        case startingPrice
        case startingDate
        case timer
        case timerAmount
        case rise
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
        var container = encoder.container(keyedBy: EACodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(startingPrice, forKey: .startingPrice)
        try container.encode(startingDate, forKey: .startingDate)
        try container.encode(timer, forKey: .timer)
        try container.encode(timerAmount, forKey: .timerAmount)
        try container.encode(rise, forKey: .rise)
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: EACodingKeys.self)
        startingPrice = try values.decode(Int.self, forKey: .startingPrice)
        startingDate = try values.decode(Date.self, forKey: .startingDate)
        timer = try values.decode(Int.self, forKey: .timer)
        timerAmount = try values.decode(Int.self, forKey: .timerAmount)
        rise = try values.decode(Int.self, forKey: .rise)
        try super.init(from: decoder)
    }
}
