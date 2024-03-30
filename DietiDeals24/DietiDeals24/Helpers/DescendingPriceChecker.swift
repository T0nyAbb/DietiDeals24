//
//  DescendingPriceChecker.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 29/03/24.
//

import Foundation

class DescendingPriceChecker {
    
    func checkAuctionFields(startingPrice: Int?, minimumPrice: Int?, decrementAmount: Int?, startingDate: Date?) throws -> Bool {
        
        //A required field is null
        if(startingPrice == nil || minimumPrice == nil || decrementAmount == nil || startingDate == nil) {
            throw UserError.invalidFields
        }
        
        //Starting price is not greater than 0
        if(startingPrice! <= 0) {
            return false
        }
        
        //Minimum price is not greater than 0
        if(minimumPrice! <= 0) {
            return false
        }
        
        //Decrement amount is not greater than 0
        if(decrementAmount! <= 0) {
            return false
        }
        
        //Decrement amount is greater than starting price
        if(decrementAmount! > startingPrice!) {
            return false
        }
        
        //Minimum price greater or equal than starting price
        if(minimumPrice! >= startingPrice!) {
            return false
        }
        
        //Starting Date already passed
        if(startingDate! < Date()) {
            return false
        }
        return true
    }
}
