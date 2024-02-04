//
//  MyAuctionsView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 22/01/24.
//

import SwiftUI

struct MyAuctionsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("My Auctions View")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            .navigationTitle("My Auctions")
        }
    }
}

#Preview {
    MyAuctionsView()
}
