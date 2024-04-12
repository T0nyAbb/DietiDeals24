//
//  AuctionsView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 22/01/24.
//

import SwiftUI

struct AuctionsView: View {
    
    @State private var search: String = ""
    @Binding var selectedAuction: Int
    @State private var showCurrentUserOnly: Bool = false
    
    var auctionViewModel: AuctionViewModel
    
    var userViewModel: UserViewModel
    
    var notificationViewModel: NotificationViewModel
    

    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    Picker("Auction type", selection: $selectedAuction) {
                        Text("Fixed Time").tag(0)
                        Text("Inverse").tag(1)
                        Text("English").tag(2)
                        Text("Descending Price").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    Divider()
                    if selectedAuction == 0 {
                        FixedTimeAuctionListView(auctionViewModel: auctionViewModel, userViewModel: userViewModel, search: $search, showCurrentUserOnly: $showCurrentUserOnly)
                            .padding(.bottom, 30)
                            .id(UUID())
                    } else if selectedAuction == 1 {
                        InverseAuctionListView(auctionViewModel: auctionViewModel, userViewModel: userViewModel, search: $search, showCurrentUserOnly: $showCurrentUserOnly)
                    } else if selectedAuction == 2 {
                        EnglishAuctionListView(auctionViewModel: auctionViewModel, userViewModel: userViewModel, search: $search, showCurrentUserOnly: $showCurrentUserOnly)
                    } else if selectedAuction == 3 {
                        DescendingPriceAuctionListView(auctionViewModel: auctionViewModel, userViewModel: userViewModel, search: $search, showCurrentUserOnly: $showCurrentUserOnly)
                    }
                }
                .searchable(text: $search, prompt: Text("Search by Title or Category"))
                
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("Auctions")
            .refreshable {
                do {
                    try await auctionViewModel.getAllFixedTimeAuction()
                    try await auctionViewModel.getAllDescendingPriceAuctions()
                    try await auctionViewModel.getAllEnglishAuctions()
                    try await auctionViewModel.getAllInverseAuctions()
                    try await notificationViewModel.updateCurrentUserNotifications(user: LoginViewModel.shared.user!)
                } catch {
                    print(error)
                }
            }
        }
        
        
        

    }
}

#Preview {
    AuctionsView(selectedAuction: .constant(0), auctionViewModel: AuctionViewModel(), userViewModel: UserViewModel(), notificationViewModel: NotificationViewModel())
}
