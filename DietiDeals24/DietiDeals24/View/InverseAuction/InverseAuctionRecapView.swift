//
//  InverseAuctionRecapView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 05/04/24.
//

import SwiftUI

struct InverseAuctionRecapView: View {
    
    @State var image: UIImage?
    @State var title: String
    @State var description: String?
    @State var category: Category
    @State var selectedDate: Date
    @State var maximumPrice: Int
    @Binding var popToRoot: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var isPresented: Bool = false
    @State private var showError: Bool = false
    var auctionViewModel: AuctionViewModel = AuctionViewModel()
    var imageViewModel: ImageViewModel = ImageViewModel()
    @State var user: User = LoginViewModel.shared.user!
    @State var auction: InverseAuction?
    
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
                    .frame(width: UIScreen.main.bounds.width*0.95, height: 300)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .frame(width: UIScreen.main.bounds.width*0.95, height: 300)
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.largeTitle)
                    .bold()
                HStack {
                    Text(category.description)
                    Spacer()
                    HStack {
                        Image(systemName: "person")
                        Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                            .bold()
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                Divider()
                VStack {
                    Text(description ?? "No description")
                        .frame(maxWidth: .infinity)
                } .padding(.top)
            }
            .padding()
            Divider()
            VStack {
                HStack {
                    Text("Expiry Date:")
                        .font(.caption)
                        .padding(.leading)
                    Text(selectedDate.formatted(date: .numeric, time: .omitted))
                        .font(.title3)
                        .bold()
                    Spacer()
                        Text("Maximum price")
                            .font(.caption)
                            .padding(.trailing)
                }
                HStack {
                    Text("Expiry Time:")
                        .font(.caption)
                        .padding(.leading)
                    Text(selectedDate.formatted(date: .omitted, time: .standard))
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text("\(maximumPrice) €")
                        .font(.title)
                        .bold()
                        .padding(.trailing)
                }

            }.padding(.vertical)
            VStack {
                Spacer()
                Button {
                    Task {
                        self.auction = try await auctionViewModel.createInverseAuction(auction: .init(id: nil, title: title, description: description, category: category.description, sellerId: user.id!, urlPicture: nil, active: nil, failed: nil, currentPrice: 0, startingPrice: maximumPrice, expiryDate: selectedDate))
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
                                            self.auction = try await auctionViewModel.updateInverseAuction(auction: self.auction!)
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
                            self.auction = .init(id: nil, title: title, description: description, category: category.description, sellerId: user.id!, urlPicture: nil, active: nil, failed: nil, currentPrice: 0, startingPrice: maximumPrice, expiryDate: selectedDate)
                        }
                }
            }
        .navigationBarBackButtonHidden(!popToRoot)
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
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
    InverseAuctionRecapView(title: "Test", description: "teststetst", category: .automotive, selectedDate: Date(), maximumPrice: 10, popToRoot: .constant(true))
}
