//
//  Constants.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 14/03/24.
//

import Foundation

enum Constants {
    static let BASE_URL = "http://localhost:8080"
    
    static func getEndpoint(endpoint: Endpoint) -> String {
        switch endpoint {
        case .LOGIN:
            return "/api/login"
        case .REGISTER:
            return "/api/register"
        case .USER:
            return "/api/user/"
        case .FIXED_TIME_AUCTION:
            return "/api/fixed_time_auction"
        }
    }
    
}
