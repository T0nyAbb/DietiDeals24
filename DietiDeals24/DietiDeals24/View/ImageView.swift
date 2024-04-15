//
//  ImageView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 01/04/24.
//

import SwiftUI

struct ImageView: View {
    
    @State var pictureUrl: String?
    @State var isProfilePicture: Bool = false
    
    var body: some View {
        VStack {
            if let auctionImage = pictureUrl {
                AsyncImage(url: URL(string: auctionImage)) { phase in
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
                if isProfilePicture {
                    Image(systemName: "person.circle")
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}

#Preview {
    ImageView(pictureUrl: "https://m.media-amazon.com/images/I/41TuK9whOAL._AC_UF1000,1000_QL80_.jpg")
}
