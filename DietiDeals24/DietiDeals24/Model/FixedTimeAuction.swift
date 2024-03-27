//
//  FixedTimeAuction.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 20/03/24.
//

import Foundation

class FixedTimeAuction: Auction, Identifiable {
    var minimumPrice: Int
    var expiryDate: Date
    
    init(id: Int?, title: String, description: String?, category: String?, sellerId: Int, urlPicture: String?, isActive: Bool?, isFailed: Bool?, currentPrice: Double?, minimumPrice: Int, expiryDate: Date) {
        self.minimumPrice = minimumPrice
        self.expiryDate = expiryDate
        super.init(id: id, title: title, description: description, category: category, sellerId: sellerId, urlPicture: urlPicture, isActive: isActive, isFailed: isFailed, currentPrice: currentPrice ?? 0)
    }
    
    enum FTACodingKeys: String, CodingKey {
        case minimumPrice
        case expiryDate
        case id
        case title
        case description
        case category
        case sellerId
        case urlPicture
        case isActive
        case isFailed
        case currentPrice
    }
    
    override func encode(to encoder: any Encoder) throws {

        var container = encoder.container(keyedBy: FTACodingKeys.self)
        print("Encoding FT Auction")
        try super.encode(to: encoder)
        try container.encode(minimumPrice, forKey: .minimumPrice)
        try container.encode(expiryDate, forKey: .expiryDate)
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: FTACodingKeys.self)
        print("Decoding FT Auction")
        minimumPrice = try values.decode(Int.self, forKey: .minimumPrice)
        print("decoded minimum price: \(minimumPrice)")
        expiryDate = try values.decode(Date.self, forKey: .expiryDate)
        print("decoded expiry date: \(expiryDate)")
        try super.init(from: decoder)
    }
    
}

