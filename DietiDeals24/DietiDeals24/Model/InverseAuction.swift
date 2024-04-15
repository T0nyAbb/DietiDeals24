//
//  InverseAuction.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 20/03/24.
//

import Foundation

class InverseAuction: Auction, Identifiable {
    var startingPrice: Int
    var expiryDate: Date
    
    init(id: Int?, title: String, description: String?, category: String?, sellerId: Int, urlPicture: String?, active: Bool?, failed: Bool?, currentPrice: Double?, startingPrice: Int, expiryDate: Date) {
        self.startingPrice = startingPrice
        self.expiryDate = expiryDate
        super.init(id: id, title: title, description: description, category: category, sellerId: sellerId, urlPicture: urlPicture, active: active, failed: failed, currentPrice: currentPrice ?? 0)
    }
    
    enum IACodingKeys: String, CodingKey {
        case startingPrice
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

        var container = encoder.container(keyedBy: IACodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(startingPrice, forKey: .startingPrice)
        try container.encode(expiryDate, forKey: .expiryDate)
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: IACodingKeys.self)
        startingPrice = try values.decode(Int.self, forKey: .startingPrice)
        expiryDate = try values.decode(Date.self, forKey: .expiryDate)
        try super.init(from: decoder)
    }
    
    
}
