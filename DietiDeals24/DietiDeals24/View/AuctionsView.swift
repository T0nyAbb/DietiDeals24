//
//  AuctionsView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 22/01/24.
//

import SwiftUI

struct AuctionsView: View {
    
    @State private var search: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if true {
                    ContentUnavailableView {
                        Label("No Active Auctions", systemImage: "tag")
                    }
                } else {
                    Text("Auctions View")
                        .font(.title)
                }
            }
                .searchable(text: $search)
                .navigationTitle("Auctions")
        }
        
        
        

    }
}

#Preview {
    AuctionsView()
}
