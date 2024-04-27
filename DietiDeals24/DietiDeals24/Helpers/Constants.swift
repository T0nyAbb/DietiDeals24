//
//  Constants.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 14/03/24.
//

import Foundation

enum Constants {
//    static let BASE_URL = "http://192.168.1.124:8080"
//    static let BASE_URL = "http://localhost:8080"
//    static let BASE_URL = "http://10.20.56.207:8080"
    static let BASE_URL = "http://ec2-16-171-118-237.eu-north-1.compute.amazonaws.com:8080"
    
    static let CLOUDFRONT_URL = "https://d3qjtqctuorn0o.cloudfront.net/public/"
    
    static func getEndpoint(endpoint: Endpoint) -> String {
        switch endpoint {
        case .LOGIN:
            return "/api/login"
        case .REGISTER:
            return "/api/register"
        case .USER:
            return "/api/user"
        case .FIXED_TIME_AUCTION:
            return "/api/fixed_time_auction"
        case .DESCENDING_PRICE_AUCTION:
            return "/api/descending_price_auction"
        case .ENGLISH_AUCTION:
            return "/api/english_auction"
        case .INVERSE_AUCTION:
            return "/api/inverse_auction"
        case .OFFER:
            return "/api/offer"
        case .DELETE_AUCTION:
            return "/api/delete_auction/"
        case .NOTIFICATION:
            return "/api/notification/"
        }
    }
    
}
