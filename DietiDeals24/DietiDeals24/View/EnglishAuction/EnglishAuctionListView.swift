//
//  EnglishAuctionListView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 30/03/24.
//

import SwiftUI

struct EnglishAuctionListView: View {
    var auctionViewModel: AuctionViewModel
    
    var userViewModel: UserViewModel
    
    @Binding var search: String
    
    @Binding var showCurrentUserOnly: Bool
    
    var filteredAuctions: [EnglishAuction] {
        guard !search.isEmpty else { return showCurrentUserOnly ? auctionViewModel.currentUserEnglishAuctions : auctionViewModel.englishAuctions}
        return showCurrentUserOnly ? auctionViewModel.currentUserEnglishAuctions.filter { $0.title.localizedCaseInsensitiveContains(search) || $0.category!.localizedCaseInsensitiveContains(search)} : auctionViewModel.englishAuctions.filter { $0.title.localizedCaseInsensitiveContains(search) || $0.category!.localizedCaseInsensitiveContains(search)}
    }
    
    
    var body: some View {
        LazyVStack {
            if !filteredAuctions.isEmpty {
                ForEach(filteredAuctions) { auction in
                    NavigationLink {
                        EnglishAuctionDetailView(englishAuction: auction, auctionViewModel: auctionViewModel)
                    } label: {
                        AuctionRowView(auction: auction)
                    }
                    .id(UUID())
                    .buttonStyle(PlainButtonStyle())
                }
                .onAppear {
                    Task {
                        do {
                            try await auctionViewModel.getAllEnglishAuctions()
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
                            try await auctionViewModel.getAllEnglishAuctions()
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
    EnglishAuctionListView(auctionViewModel: AuctionViewModel(), userViewModel: UserViewModel(), search: .constant(""), showCurrentUserOnly: .constant(false))
}
