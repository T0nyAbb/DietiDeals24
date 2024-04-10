//
//  DescendingPriceAuctionListView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 30/03/24.
//

import SwiftUI

struct DescendingPriceAuctionListView: View {
    var auctionViewModel: AuctionViewModel
    
    var userViewModel: UserViewModel
    
    @State var currentDate: Date = Date()
    
    @Binding var search: String
    
    @Binding var showCurrentUserOnly: Bool
    
    var filteredAuctions: [DescendingPriceAuction] {
        guard !search.isEmpty else { return showCurrentUserOnly ? auctionViewModel.currentUserDescendingPriceAuctions : auctionViewModel.descendingPriceAuctions}
        return showCurrentUserOnly ? auctionViewModel.currentUserDescendingPriceAuctions.filter { $0.title.localizedCaseInsensitiveContains(search) || $0.category!.localizedCaseInsensitiveContains(search)} : auctionViewModel.descendingPriceAuctions.filter { $0.title.localizedCaseInsensitiveContains(search) || $0.category!.localizedCaseInsensitiveContains(search)}
    }
    
    
    var body: some View {
        LazyVStack {
            if !filteredAuctions.isEmpty {
                ForEach(filteredAuctions) { auction in
                    NavigationLink {
                        DescendingPriceAuctionDetailView(descendingPriceAuction: auction, auctionViewModel: auctionViewModel)
                    } label: {
                        AuctionRowView(auction: auction)
                    }
                    .id(UUID())
                    .buttonStyle(PlainButtonStyle())
                }
                .onAppear {
                    Task {
                        do {
                            try await auctionViewModel.getAllDescendingPriceAuctions()
                        } catch {
                            print("Error")
                        }
                    }
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
                .onAppear {
                    Task {
                        do {
                            try await auctionViewModel.getAllDescendingPriceAuctions()
                        } catch {
                            print("Error")
                        }
                    }
                }
            }

        }
    }
}

#Preview {
    DescendingPriceAuctionListView(auctionViewModel: AuctionViewModel(), userViewModel: UserViewModel(), search: .constant(""), showCurrentUserOnly: .constant(false))
}
