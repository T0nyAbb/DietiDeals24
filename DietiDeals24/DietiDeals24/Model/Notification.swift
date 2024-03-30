//
//  Notification.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 29/03/24.
//

import Foundation

struct Notification: Codable, Identifiable {
    let id: UUID = UUID()
    let notificationId: Int
    let auctionId: Int
    let receiverId: Int
    let body: String
    
    
    init(notificationId: Int, auctionId: Int, receiverId: Int, body: String) {
        self.notificationId = notificationId
        self.auctionId = auctionId
        self.receiverId = receiverId
        self.body = body
    }
    
}
