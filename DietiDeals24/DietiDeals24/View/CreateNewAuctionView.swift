//
//  CreateNewAuctionView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 20/03/24.
//

import SwiftUI

struct CreateNewAuctionView: View {
    
    @Binding var rootIsActive: Bool
    @Environment(\.dismiss) private var dismiss
    @State var showInfo: Bool = false
    @State var user: User
    
    var disableSellerAuctions: Bool {
        return user.vatNumber == nil || user.nationalInsuranceNumber == nil
    }
    
    var disableBuyerAuctions: Bool {
        return user.iban == nil
    }
    
    var body: some View {
        if rootIsActive {
            VStack {
                Spacer()
                NavigationLink(destination: CreateNewFixedTimeAuctionView(rootIsActive: self.$rootIsActive)) {
                    HStack {
                        Image(systemName: "timer")
                            .font(.title)
                        Text("Fixed Time Auction")
                    }
                    .padding()
                    .overlay {
                        if disableSellerAuctions {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.separator , lineWidth: 3)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary , lineWidth: 3)
                        }
                    }
                    .font(.title2)
                }
                .isDetailLink(false)
                .id(UUID())
                .disabled(disableSellerAuctions)
                Spacer()
                NavigationLink {
                    CreateNewEnglishAuctionView(rootIsActive: self.$rootIsActive)
                } label: {
                    HStack {
                        Image(systemName: "eurosign")
                            .font(.title)
                        Text("English Auction")
                    }
                    .padding()
                    .overlay {
                        if disableSellerAuctions {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.separator , lineWidth: 3)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary , lineWidth: 3)
                        }
                    }
                    .font(.title2)
                }
                .isDetailLink(false)
                .id(UUID())
                .disabled(disableSellerAuctions)
                Spacer()
                NavigationLink {
                    CreateNewDescendingPriceAuctionView(rootIsActive: self.$rootIsActive)
                } label: {
                    HStack {
                        Image(systemName: "eurosign.arrow.circlepath")
                            .font(.title)
                        Text("Descending Price Auction")
                    }
                    .padding()
                    .overlay {
                        if disableSellerAuctions {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.separator , lineWidth: 3)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary , lineWidth: 3)
                        }
                    }
                    .font(.title2)
                }
                .isDetailLink(false)
                .id(UUID())
                .disabled(disableSellerAuctions)
                Spacer()
                NavigationLink {
                    CreateNewInverseAuctionView(rootIsActive: self.$rootIsActive)
                } label: {
                    HStack {
                        Image(systemName: "arrow.circlepath")
                            .font(.title)
                        Text("Inverse Auction")
                    }
                    .padding()
                    .overlay {
                        if disableBuyerAuctions {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.separator , lineWidth: 3)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary , lineWidth: 3)
                        }
                    }
                    .font(.title2)
                }
                .isDetailLink(false)
                .id(UUID())
                .disabled(disableBuyerAuctions)
                Spacer()
                    .navigationTitle("Auction Type")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showInfo = true
                            } label: {
                                Image(systemName: "info.circle")
                            }
                        }
                    }
                    .sheet(isPresented: $showInfo, content: {
                        AuctionInfoView()
                    })
            }

        } else {
            Text("")
                .navigationBarBackButtonHidden()
                .onAppear {
                    dismiss()
                }
        }
    }
}

#Preview {
    CreateNewAuctionView(rootIsActive: .constant(true), user: User(id: 0, firstName: nil, lastName: nil, username: "acac", password: nil, bio: nil, website: nil, social: nil, geographicArea: nil, google: nil, facebook: nil, apple: nil, profilePicture: nil, iban: "ac", vatNumber: nil, nationalInsuranceNumber: nil))
}
