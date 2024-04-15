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
    @State var description: String?
    @State var category: Category
    @State var selectedDate: Date
    @State var minimumPrice: Int
    @Binding var popToRoot: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var isPresented: Bool = false
    @State private var showError: Bool = false
    var auctionViewModel: AuctionViewModel = AuctionViewModel()
    var imageViewModel: ImageViewModel = ImageViewModel()
    @State var user: User = LoginViewModel.shared.user!
    @State var auction: FixedTimeAuction?
    
    
    
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
            Text(description ?? "No Description")
                .padding()
            Text(category.description)
                .padding()
            Text("Expiry Date: \(selectedDate.formatted(date: .numeric, time: .standard))")
                .padding()
            Text("Minimum Price: \(minimumPrice) €")
                .padding()
            VStack {
                Spacer()
                Button {
                    Task {
                        self.auction = try await auctionViewModel.createFixedTimeAuction(auction: .init(id: nil, title: title, description: description, category: category.description, sellerId: user.id!, urlPicture: nil, active: nil, failed: nil, currentPrice: 0, minimumPrice: minimumPrice, expiryDate: selectedDate))
                        if self.auction != nil {
                            if self.image != nil {
                                    do {
                                        imageViewModel.uiImage = self.image
                                        let image = try await imageViewModel.uploadAuctionPicture(auction: self.auction!)
                                        print("auction image uploaded: \(image)")
                                        let imageUrl = try await imageViewModel.getAuctionPictureUrl(auction: self.auction!)
                                        print("image url saved: \(imageUrl)")
                                        self.auction?.urlPicture = imageUrl
                                        print("updated auction picture")
                                        do {
                                            self.auction = try await auctionViewModel.updateFixedTimeAuction(auction: self.auction!)
                                            print("updated auction in db!")
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                                                self.isPresented = true

                                            }
                                        } catch {
                                            print("failed updating auction")
                                            print(error)
                                            self.showError = true
                                        }
                                    } catch {
                                        print("image upload failed")
                                        print(error)
                                        self.showError = true
                                    }
                            } else {
                                self.isPresented = true
                            }

                        }
                    }
                } label: {
                    Text("Publish")
                        .frame(width: 360, height: 45)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .onAppear {
                            self.auction = .init(id: nil, title: title, description: description, category: category.description, sellerId: user.id!, urlPicture: nil, active: nil, failed: nil, currentPrice: 0, minimumPrice: minimumPrice, expiryDate: selectedDate)
                        }
                }

            }

        .navigationBarBackButtonHidden(!popToRoot)
        .navigationTitle("Summary")


        }
        .alert(isPresented: $isPresented, content: {
            if !showError {
                Alert(title: Text("Auction Published!"), dismissButton: .default(Text("Ok"), action: {
                    self.popToRoot = false
                    dismiss()
                }))
            } else {
                Alert(title: Text("Error uploading auction!"), dismissButton: .default(Text("Ok"), action: {
                    self.showError = false
                }))

            }
        })

    }
}

#Preview {
    FixedAuctionRecapView(title: "Test", description: "teststetst", category: .automotive, selectedDate: Date(), minimumPrice: 10, popToRoot: .constant(true))
}
