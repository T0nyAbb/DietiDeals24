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
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 3)
                    }
                    .font(.title2)
                }
                .isDetailLink(false)
                .id(UUID())
                Spacer()
                NavigationLink {
                    CreateNewEnglishAuctionView()
                } label: {
                    HStack {
                        Image(systemName: "eurosign")
                            .font(.title)
                        Text("English Auction")
                    }
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 3)
                    }
                    .font(.title2)
                }
                .isDetailLink(false)
                .id(UUID())
                Spacer()
                NavigationLink {
                    CreateNewDescendingPriceAuction(rootIsActive: self.$rootIsActive)
                } label: {
                    HStack {
                        Image(systemName: "eurosign.arrow.circlepath")
                            .font(.title)
                        Text("Descending Price Auction")
                    }
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 3)
                    }
                    .font(.title2)
                }
                .isDetailLink(false)
                .id(UUID())
                Spacer()
                NavigationLink {
                    CreateNewInverseAuctionView()
                } label: {
                    HStack {
                        Image(systemName: "arrow.circlepath")
                            .font(.title)
                        Text("Inverse Auction")
                    }
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 3)
                    }
                    .font(.title2)
                }
                .isDetailLink(false)
                .id(UUID())
                Spacer()
                    .navigationTitle("Auction Type")
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
    CreateNewAuctionView(rootIsActive: .constant(true))
}
