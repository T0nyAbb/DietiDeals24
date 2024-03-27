//
//  FixedAuctionRecapView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 23/03/24.
//

import SwiftUI

struct FixedAuctionRecapView: View {
    
    @State var image: UIImage?
    @State var title: String
    @State var description: String
    @State var category: Category
    @State var selectedDate: Date
    @State var minimumPrice: Int
    @Binding var popToRoot: Bool
    @Environment(\.dismiss) private var dismiss
    @State var isPresented: Bool = false
    var auctionViewModel: AuctionViewModel = AuctionViewModel()
    @State var user: User = LoginViewModel.shared.user!
    
    
    
    var body: some View {
        VStack {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 125, height: 125)
                    .padding()
            } else {
                Text("No Image")
                    .font(.title2)
            }
            Text(title)
                .font(.title)
                .bold()
                .padding()
            Text(description)
                .padding()
            Text(category.description)
                .padding()
            Text("Expiry Date: \(selectedDate)")
                .padding()
            Text("Minimum Price: \(minimumPrice) €")
                .padding()
            VStack {
                Spacer()
                Button {
                    self.popToRoot = false
                    self.isPresented = true
                } label: {
                    Text("Publish")
                        .frame(width: 360, height: 45)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
        }
        .navigationBarBackButtonHidden(!popToRoot)
        .navigationTitle("Summary")
        .alert(isPresented: $isPresented, content: {
            Alert(title: Text("Auction Published!"), dismissButton: .default(Text("Ok"), action: {
                Task {
                    
                    let fixedTimeAuction = try await auctionViewModel.createFixedTimeAuction(auction: .init(id: nil, title: title, description: description, category: category.description, sellerId: user.id!, urlPicture: nil, isActive: nil, isFailed: nil, currentPrice: 0, minimumPrice: minimumPrice, expiryDate: selectedDate))
                    print(fixedTimeAuction)
                }
//                dismiss()
            }))
        })
    }
}

#Preview {
    FixedAuctionRecapView(title: "Test", description: "teststetst", category: .automotive, selectedDate: Date(), minimumPrice: 10, popToRoot: .constant(true))
}
