//
//  DescendingPriceAuctionRecapView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 29/03/24.
//

import SwiftUI

struct DescendingPriceAuctionRecapView: View {
    @State var image: UIImage?
    @State var title: String
    @State var description: String?
    @State var category: Category
    @State var startingPrice: Int
    @State var selectedDate: Date = Date().advanced(by: .days(2))
    @State var minimumPrice: Int
    @State var timerAmount: Int
    @State var reductionAmount: Int
    @Binding var popToRoot: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var isPresented: Bool = false
    @State private var showError: Bool = false
    var auctionViewModel: AuctionViewModel = AuctionViewModel()
    var imageViewModel: ImageViewModel = ImageViewModel()
    @State var user: User = LoginViewModel.shared.user!
    @State var auction: DescendingPriceAuction?
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
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
                    Text("Starting Price:")
                        .font(.caption)
                        .padding(.leading)
                    Text("\(startingPrice) €")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                HStack {
                    Text("Decreasing by:")
                        .font(.caption)
                        .padding(.leading)
                    Text("\(reductionAmount) €")
                        .font(.title3)
                        .bold()
                    Text("Every")
                        .font(.caption)
                    Text("^[\(timerAmount) Minute](inflect: true)")
                        .font(.title3)
                        .bold()
                        .padding(.trailing)
                    Spacer()
                }
                HStack {
                    Text("Minimum selling price:")
                        .font(.caption)
                        .padding(.leading)
                    Text("\(minimumPrice) €")
                        .font(.title3)
                        .bold()
                    Spacer()
                }

            }.padding(.vertical)
            VStack {
                Spacer()
                Button {
                    Task {
                        self.auction = try await auctionViewModel.createDescendingPriceAuction(auction: .init(id: nil, title: title, description: description, category: category.description, sellerId: user.id!, urlPicture: nil, active: nil, failed: nil, currentPrice: Double(startingPrice), startingPrice: startingPrice, startingDate: selectedDate, timer: nil, timerAmount: timerAmount*60, reduction: reductionAmount, minimumPrice: minimumPrice))
                        if self.auction != nil {
                            if self.image != nil {
                                do {
                                    imageViewModel.uiImage = self.image
                                    let image = try await imageViewModel.uploadAuctionPicture(auction: self.auction!)
                                    print("auction image uploaded: \(image)")
                                    let imageUrl = imageViewModel.getAuctionPictureUrl(auction: self.auction!)
                                    print("image url saved: \(imageUrl)")
                                    self.auction?.urlPicture = imageUrl
                                    print("updated auction picture")
                                    do {
                                        self.auction = try await auctionViewModel.updateDescendingPriceAuction(auction: self.auction!)
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
                            self.auction = .init(id: nil, title: title, description: description, category: category.description, sellerId: user.id!, urlPicture: nil, active: nil, failed: nil, currentPrice: 0, startingPrice: startingPrice, startingDate: selectedDate, timer: nil, timerAmount: timerAmount*60, reduction: reductionAmount, minimumPrice: minimumPrice)
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
    DescendingPriceAuctionRecapView(title: "Test", description: "teststetst", category: .automotive, startingPrice: 20, selectedDate: Date(), minimumPrice: 10, timerAmount: 60, reductionAmount: 2, popToRoot: .constant(true))
}
