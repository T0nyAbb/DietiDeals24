//
//  Category.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 23/03/24.
//

import Foundation

enum Category: String, CaseIterable {
    case electronics
    case clothing
    case books
    case groceries
    case furniture
    case beauty
    case sportsEquipment
    case toys
    case automotive
    case homeAppliances
    
    var description: String {
        switch self {
        case .electronics:
            return "Electronics"
        case .clothing:
            return "Clothing"
        case .books:
            return "Books"
        case .groceries:
            return "Groceries"
        case .furniture:
            return "Furniture"
        case .beauty:
            return "Beauty"
        case .sportsEquipment:
            return "Sports Equipment"
        case .toys:
            return "Toys"
        case .automotive:
            return "Automotive"
        case .homeAppliances:
            return "Home Appliances"
        }
    }
}

