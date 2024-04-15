//
//  InverseAuctionListView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 05/04/24.
//

import SwiftUI

struct InverseAuctionListView: View {
    
    var auctionViewModel: AuctionViewModel
    
    var userViewModel: UserViewModel
    
    @State var currentDate: Date = Date()
    
    @Binding var search: String
    
    @Binding var showCurrentUserOnly: Bool
    
    var filteredAuctions: [InverseAuction] {
        guard !search.isEmpty else { return showCurrentUserOnly ? auctionViewModel.currentUserInverseAuctions : auctionViewModel.inverseAuctions}
        return showCurrentUserOnly ? auctionViewModel.currentUserInverseAuctions.filter { $0.title.localizedCaseInsensitiveContains(search) || $0.category!.localizedCaseInsensitiveContains(search)} : auctionViewModel.inverseAuctions.filter { $0.title.localizedCaseInsensitiveContains(search) || $0.category!.localizedCaseInsensitiveContains(search)}
    }
    
    
    var body: some View {
        LazyVStack {
            if !filteredAuctions.isEmpty {
                ForEach(filteredAuctions) { auction in
                    NavigationLink {
                        InverseAuctionDetailView(inverseAuction: auction, auctionViewModel: auctionViewModel, user: userViewModel.users.first {
                            $0.id! == auction.sellerId
                        })
                    } label: {
                        AuctionRowView(auction: auction)
                    }
                    .id(UUID())
                    .buttonStyle(PlainButtonStyle())
                }
                .onAppear {
                    Task {
                        do {
                            try await auctionViewModel.getAllInverseAuctions()
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
                            try await auctionViewModel.getAllInverseAuctions()
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
    FixedTimeAuctionListView(auctionViewModel: AuctionViewModel(), userViewModel: UserViewModel(), search: .constant(""), showCurrentUserOnly: .constant(false))
}

