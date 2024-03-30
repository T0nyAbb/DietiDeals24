//
//  AuctionListView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 19/03/24.
//

import SwiftUI
import CachedAsyncImage


struct FixedTimeAuctionListView: View {
    
    var auctionViewModel: AuctionViewModel
    
    var userViewModel: UserViewModel
    
    @State var currentDate = Date()
    
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
                            VStack {
                                Text(auction.title)
                                    .font(.title2)
                                    .bold()
                                Spacer()
                                Text("Expires on:")
                                Text(auction.expiryDate.formatted(date: .numeric, time: .standard))
                                    .font(.caption)
                                    .bold()
                            }
                            .padding(.vertical)
                            Spacer()
                            Text("\(auction.currentPrice, specifier: "%.2f") €")
                                .font(.title)
                                .bold()
                        }
                        .padding()
                    }
                    .id(UUID())
                    .buttonStyle(PlainButtonStyle())
                }
                .onAppear {
                    Task {
                        do {
                            try await auctionViewModel.getAllFixedTimeAuction()
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
                            try await auctionViewModel.getAllFixedTimeAuction()
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
