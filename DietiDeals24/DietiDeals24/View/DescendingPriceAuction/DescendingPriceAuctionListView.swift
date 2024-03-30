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
    
    @State var currentDate = Date()
    
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
                                Text("Price reduction every:")
                                    .font(.caption)
                                Text("^[\(Int(auction.timerAmount/60)) Minute](inflect: true)")
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
