//
//  MyAuctionsView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 22/01/24.
//

import SwiftUI

struct MyAuctionsView: View {
    
    var userVm: UserViewModel = UserViewModel()
    var loginVm: LoginViewModel
    var auctionVm: AuctionViewModel
    var notificationViewModel: NotificationViewModel
    @State private var user: User?
    @State private var isPresented: Bool = false
    @Binding var selectedAuction: Int
    @State private var search: String = ""
    @State private var showCurrentUserOnly: Bool = true
    @State var isActive: Bool = true
    
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
                        FixedTimeAuctionListView(auctionViewModel: auctionVm, userViewModel: userVm, search: $search, showCurrentUserOnly: $showCurrentUserOnly)
                            .padding(.bottom, 30)
                            .id(UUID())
                    } else if selectedAuction == 1 {
                        Text("Auctions View")
                            .font(.title)
                    } else if selectedAuction == 2 {
                        EnglishAuctionListView(auctionViewModel: auctionVm, userViewModel: userVm, search: $search, showCurrentUserOnly: $showCurrentUserOnly)
                            .padding(.bottom, 30)
                            .id(UUID())
                    } else if selectedAuction == 3 {
                        DescendingPriceAuctionListView(auctionViewModel: auctionVm, userViewModel: userVm, search: $search, showCurrentUserOnly: $showCurrentUserOnly)
                            .padding(.bottom, 30)
                            .id(UUID())
                    }
                    
                }
                .onAppear {
                    Task {
                        do {
                            try await auctionVm.getAllFixedTimeAuction()
                        } catch {
                            print("Error")
                        }
                    }
                }
                .searchable(text: $search, prompt: Text("Search by Title or Category"))
            }
            .scrollDismissesKeyboard(.immediately)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: CreateNewAuctionView(rootIsActive: self.$isActive)) {
                        Image(systemName: "plus")
                    }
                }
            }
            .refreshable {
                do {
                    try await auctionVm.getAllFixedTimeAuction()
                    try await auctionVm.getAllDescendingPriceAuctions()
                    try await auctionVm.getAllEnglishAuctions()
                    try await auctionVm.getAllInverseAuctions()
                    try await notificationViewModel.updateCurrentUserNotifications(user: loginVm.user!)
                } catch {
                    print(error)
                }
            }
            .navigationTitle("My Auctions")
        }
    }
}

#Preview {
    MyAuctionsView(loginVm: LoginViewModel.shared, auctionVm: AuctionViewModel(), notificationViewModel: NotificationViewModel(), selectedAuction: .constant(0))
}
