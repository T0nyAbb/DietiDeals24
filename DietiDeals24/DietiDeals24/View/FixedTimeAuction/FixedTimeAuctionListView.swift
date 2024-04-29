//
//  AuctionListView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 19/03/24.
//

import SwiftUI



struct FixedTimeAuctionListView: View {
    
    var auctionViewModel: AuctionViewModel
    
    var userViewModel: UserViewModel
    
    @State var currentDate: Date = Date()
    
    @Binding var search: String
    
    @Binding var showCurrentUserOnly: Bool
    
    var filteredAuctions: [FixedTimeAuction] {
        guard !search.isEmpty else { return showCurrentUserOnly ? auctionViewModel.currentUserFixedTimeAuctions : auctionViewModel.fixedTimeAuctions}
        return showCurrentUserOnly ? auctionViewModel.currentUserFixedTimeAuctions.filter { $0.title.localizedCaseInsensitiveContains(search) || $0.category!.localizedCaseInsensitiveContains(search)} : auctionViewModel.fixedTimeAuctions.filter { $0.title.localizedCaseInsensitiveContains(search) || $0.category!.localizedCaseInsensitiveContains(search)}
    }
    
    
    var body: some View {
        LazyVStack {
            if !filteredAuctions.isEmpty {
                ForEach(filteredAuctions) { auction in
                    NavigationLink {
                        FixedTimeAuctionDetailView(fixedTimeAuction: auction, auctionViewModel: auctionViewModel, user: userViewModel.users.first {
                            $0.id! == auction.sellerId
                        })
                    } label: {
                        AuctionRowView(auction: auction)
                    }
                    .id(UUID())
                    .buttonStyle(PlainButtonStyle())
                }
            } else {
                ContentUnavailableView {
                    if search.isEmpty {
                        Label("No Active Auctions", systemImage: "tag")
                            .padding(.top, 140)
                    } else {
                        Label("No Results", systemImage: "tag")
                            .padding(.top, 140)
                    }
                }

            }

        }

    }
}

#Preview {
    FixedTimeAuctionListView(auctionViewModel: AuctionViewModel(), userViewModel: UserViewModel(), search: .constant(""), showCurrentUserOnly: .constant(false))
}
