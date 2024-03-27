//
//  Auction.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 20/03/24.
//

import Foundation

class Auction: Codable {
    let id: Int?
    var title: String
    var description: String?
    var category: String?
    let sellerId: Int
    var urlPicture: String?
    var isActive: Bool?
    var isFailed: Bool?
    var currentPrice: Double
    
    init(id: Int?, title: String, description: String?, category: String?, sellerId: Int, urlPicture: String?, isActive: Bool?, isFailed: Bool?, currentPrice: Double) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.sellerId = sellerId
        self.urlPicture = urlPicture
        self.isActive = isActive
        self.isFailed = isFailed
        self.currentPrice = currentPrice
    }
    
    enum CodingKeys: String, CodingKey {
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
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        print("Encoding Auction")
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(category, forKey: .category)
        try container.encode(sellerId, forKey: .sellerId)
        try container.encodeIfPresent(urlPicture, forKey: .urlPicture)
        try container.encodeIfPresent(isActive, forKey: .isActive)
        try container.encodeIfPresent(isFailed, forKey: .isFailed)
        try container.encodeIfPresent(currentPrice, forKey: .currentPrice)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        self.sellerId = try container.decode(Int.self, forKey: .sellerId)
        self.urlPicture = try container.decodeIfPresent(String.self, forKey: .urlPicture)
        self.isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive)
        self.isFailed = try container.decodeIfPresent(Bool.self, forKey: .isFailed)
        self.currentPrice = try container.decode(Double.self, forKey: .currentPrice)
    }
}
