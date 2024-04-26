//
//  AuctionInfoView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 09/04/24.
//

import SwiftUI

struct AuctionInfoView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            Text("Fixed Time Auction")
                .font(.title)
                .bold()
                .padding()
            Text("As a seller: You can set a secret minimum price visible only to you and a expiry date (after that date the auction ends).")
                .font(.callout)
                .padding()
            Text("As a bidder: You can see the current price for the product/service and the expiry date (after that date the auction ends). The highest offer when the auction expires wins")
                .font(.callout)
                .padding()
            Divider()
            Text("English Auction")
                .font(.title)
                .bold()
                .padding()
            Text("As a seller: You can set a initial price, a timer and a rise price, when someone offer on the rise the timer reset. The auction ends when the timer reaches 0.")
                .font(.callout)
                .padding()
            Text("As a bidder: You can see the current price of the product/service and the timer going down, if someone bids the timer resets, the auction is won by who made the highest bid when the timer reach 0.")
                .font(.callout)
                .padding()
            Divider()
            Text("DescendingPriceAuction")
                .font(.title)
                .bold()
                .padding()
            Text("As a seller: You can set a high starting price, a price decrease amount, a timer and a secret minimum price visible only to you. When the timer reaches 0 the price decreases and the timer resets, the auction ends when the current price reaches the minimum price or someone buys the product/service at the current price.")
                .font(.callout)
                .padding()
            Text("As a bidder: You can see the current price of the product/service and the timer decreasing, every time the timer reaches 0 the price decreases and the timer resets. The auction ends when someone decides to buy the product/service at the current price or the secret minimum price is reached.")
                .font(.callout)
                .padding()
            Divider()
            Text("InverseAuction")
                .font(.title)
                .bold()
                .padding()
            Text("As a seller: You can offer the product/service to the buyer at your own price, the provision of the product/service is won by the lowest price offer when the auction expires.")
                .font(.callout)
                .padding()
            Text("As a bidder: You can set a maximum price that you want to pay, then the sellers will compete with each other by offering the product/service to you at a lower price, the seller that offers the product/service at the lowest price will offer it to you at that price")
                .font(.callout)
                .padding()
        }
    }
}

#Preview {
    AuctionInfoView()
}
