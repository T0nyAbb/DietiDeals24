//
//  AuctionRowView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 01/04/24.
//

import SwiftUI

struct AuctionRowView: View {
    
    @State var auction: Auction
    
    var body: some View {
        HStack {
            if let imageURL = auction.urlPicture {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    if let image = phase.image {
                        // Display the loaded image
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else if phase.error != nil {
                        // Display a placeholder when loading failed
                        Image(systemName: "questionmark.diamond")
                            .imageScale(.large)
                    } else {
                        // Display a placeholder while loading
                        ProgressView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 100, height: 100)
            }
            if let fixedTimeAuction = auction as? FixedTimeAuction {
                VStack {
                    Text(fixedTimeAuction.title)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text("Expires on:")
                    Text(fixedTimeAuction.expiryDate.formatted(date: .numeric, time: .standard))
                        .font(.caption)
                        .bold()
                }
                .padding(.vertical)
                Spacer()
                Text("\(fixedTimeAuction.currentPrice, specifier: "%.2f") €")
                    .font(.title)
                    .bold()
            } else if let englishAuction = auction as? EnglishAuction {
                VStack {
                    Text(englishAuction.title)
                        .font(.title2)
                        .bold()
                    Spacer()
                    HStack {
                        Text("Raise:")
                            .font(.title3)
                            .bold()
                            .offset(x: 4)
                        Text("\(englishAuction.rise) €")
                            .font(.title3)
                            .bold()
                    }
                    
                }
                .padding(.vertical)
                Spacer()
                Text("\(englishAuction.currentPrice, specifier: "%.2f") €")
                    .font(.title)
                    .bold()
            } else if let inverseAuction = auction as? InverseAuction {
                VStack {
                    Text(inverseAuction.title)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text("Expires on:")
                    Text(inverseAuction.expiryDate.formatted(date: .numeric, time: .standard))
                        .font(.caption)
                        .bold()
                }
                .padding(.vertical)
                Spacer()
                Text("\(inverseAuction.currentPrice, specifier: "%.2f") €")
                    .font(.title)
                    .bold()
            } else if let descendingPriceAuction = auction as? DescendingPriceAuction {
                VStack {
                    Text(descendingPriceAuction.title)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text("Price reduction every:")
                        .font(.caption)
                    Text("^[\(Int(descendingPriceAuction.timerAmount/60)) Minute](inflect: true)")
                        .font(.caption)
                        .bold()
                }
                .padding(.vertical)
                Spacer()
                Text("\(descendingPriceAuction.currentPrice, specifier: "%.2f") €")
                    .font(.title)
                    .bold()
            }
            
        }
        .padding()
        .frame(height: 140)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 30)
                .padding(10)
        }
    }
}

#Preview("FixedTimeRow") {
    AuctionRowView(auction: FixedTimeAuction(id: 0, title: "Auction title", description: "Auction description", category: "Auction category", sellerId: 0, urlPicture: nil, active: nil, failed: nil, currentPrice: 20, minimumPrice: 30, expiryDate: Date().advanced(by: .hours(2))))
}
#Preview("EnglishRow") {
    AuctionRowView(auction: EnglishAuction(id: 0, title: "Title", description: nil, category: nil, sellerId: 0, urlPicture: nil, active: nil, failed: nil, currentPrice: 30, startingPrice: 10, startingDate: Date(), timer: 60*60, timerAmount: 60*60, rise: 100))
}
