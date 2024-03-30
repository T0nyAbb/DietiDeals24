//
//  FixedTimeAuctionDetailView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 28/03/24.
//

import SwiftUI

struct FixedTimeAuctionDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var fixedTimeAuction: FixedTimeAuction
    
    var offerViewModel = OfferViewModel()
    
    var offerChecker = OfferChecker()
    
    var auctionViewModel: AuctionViewModel
    
    @State var offer: Offer?
    
    @State var user: User?
    
    @StateObject var loginVm: LoginViewModel = LoginViewModel.shared
    
    
    @State var isPresented = false
    
    @State var showAlert = false
    
    @State var showConfirmation = false
    
    @State var offerAmount: Double = 0.0
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if let auctionImage = fixedTimeAuction.urlPicture {
                    AsyncImage(url: URL(string: auctionImage))
                        .scaledToFit()
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(width: 300, height: 300)
                        .clipped()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
            }
            .frame(width: 300, height: 300)
            VStack(alignment: .leading) {
                Text(fixedTimeAuction.title)
                    .font(.largeTitle)
                    .bold()
                HStack {
                    Text(fixedTimeAuction.category ?? "No category")
                    Spacer()
                    Image(systemName: "person")
//                    if self.user != nil {
//                        Text((user?.firstName)! + " " + (user?.lastName)!.first + ".")
//                            .bold()
//                    } else {
//                        Text("Username")
//                            .bold()
//                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                Divider()
                VStack {
                    Text(fixedTimeAuction.description ?? "No description")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                } .padding(.top)
            }
            .padding()
            HStack {
                VStack {
                    Text("\(fixedTimeAuction.currentPrice, specifier: "%.2f") €")
                        .font(.title)
                        .bold()
                    Text("Highest offer")
                        .font(.callout)
                }
                .padding()
                Spacer()
            }
            VStack {
                
                Button {
                    if loginVm.user?.id == fixedTimeAuction.sellerId {
                        self.showConfirmation = true
                        self.showAlert = true
                    } else {
                        self.isPresented = true
                    }
                } label: {
                    if loginVm.user?.id != fixedTimeAuction.sellerId {
                        Text("Offer")
                            .bold()
                            .frame(width: 360, height: 45)
                            .background(Color.green.gradient)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    } else {
                        Text("Delete")
                            .bold()
                            .frame(width: 360, height: 45)
                            .background(Color.red.gradient)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                        
                    }
                }
            }
            Spacer()
                .sheet(isPresented: $isPresented) {
                    VStack {
                        TextField("Minimum Price", value: $offerAmount, format: .currency(code: Locale.current.currency?.identifier ?? "€"), prompt: Text("Bid Amount"))
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .autocorrectionDisabled()
                            .padding()
                        Button {
                            Task {
                                if offerChecker.checkFixedTimeOffer(currentPrice: fixedTimeAuction.currentPrice, offerAmount: offerAmount) {
                                    self.offer = try await offerViewModel.createOffer(offer: .init(offerId: nil, bidderId: loginVm.user!.id!, bidAmount: offerAmount, auctionId: fixedTimeAuction.id!))
                                }
                                
                                if self.offer != nil {
                                    isPresented = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        self.showAlert = true
                                    }
                                    
                                }

                            }

                        } label: {
                            Text("Make Offer")
                                .bold()
                                .frame(width: 360, height: 45)
                                .background(Color.green.gradient)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                    .presentationDetents([.medium, .large])
                }
                .alert(isPresented: $showAlert, content: {
                    if showConfirmation {
                        Alert(title: Text("Are you sure you want to delete this auction?"),
                            message: Text("This action is permanent."),
                            primaryButton: .destructive(Text("Delete"), action: {
                            Task {
                                if try await auctionViewModel.deleteAuction(auction: fixedTimeAuction) {
                                    dismiss()
                                } 
                            }
                            }),
                            secondaryButton: .default(Text("Cancel"))
                        )
                    } else {
                        Alert(title: Text("Bid successfuly made!"), dismissButton: .default(Text("Ok"), action: {
                            fixedTimeAuction.currentPrice = offer!.bidAmount
                        }))
                    }
                })
        }
    }
}

#Preview {
    FixedTimeAuctionDetailView(fixedTimeAuction: .init(id: 0, title: "Auction title", description: "Auction description", category: "Auction category", sellerId: 0, urlPicture: nil, active: nil, failed: nil, currentPrice: 20, minimumPrice: 30, expiryDate: Date().advanced(by: .hours(2))), auctionViewModel: AuctionViewModel())
}
