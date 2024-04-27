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
    case jewelry
    case petSupplies
    case musicalInstruments
    case healthAndWellness
    case officeSupplies
    case gardening
    case kitchenware
    case outdoor
    case tools
    case stationery
    case services
    
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
        case .jewelry:
            return "Jewelry"
        case .petSupplies:
            return "Pet Supplies"
        case .musicalInstruments:
            return "Musical Instruments"
        case .healthAndWellness:
            return "Health and Wellness"
        case .officeSupplies:
            return "Office Supplies"
        case .gardening:
            return "Gardening"
        case .kitchenware:
            return "Kitchenware"
        case .outdoor:
            return "Outdoor"
        case .tools:
            return "Tools"
        case .stationery:
            return "Stationery"
        case .services:
            return "Services"
        }
    }
}

