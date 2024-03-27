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
    var auctionVm: AuctionViewModel = AuctionViewModel()
    @State private var user: User?
    @State private var isPresented: Bool = false
    @State var isActive: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if auctionVm.currentUserFixedTimeAuctions.count == 0 {
                        VStack {
                            Spacer()
                            ContentUnavailableView {
                                Spacer()
                                Label("No Auctions Published Yet", systemImage: "tag")
                                    .onAppear {
                                        self.isActive.toggle()
                                        self.isActive = true
                                    }
                            }
                        }
                        
                    } else {
                        ForEach(auctionVm.currentUserFixedTimeAuctions) { auction in
                            Text(auction.title)
                        }
                            .onAppear {
                                self.isActive = true
                            }
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
            }
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
                } catch {
                    print("Error")
                }
                
            }
            .navigationTitle("My Auctions")
            
            
        }
    }
}

#Preview {
    MyAuctionsView(loginVm: LoginViewModel.shared)
}
