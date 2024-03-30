//
//  DescendingPriceAuctionDetailView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 30/03/24.
//

import SwiftUI
import EffectsLibrary

struct DescendingPriceAuctionDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var descendingPriceAuction: DescendingPriceAuction
    
    var offerViewModel = OfferViewModel()
    
    var offerChecker = OfferChecker()
    
    var auctionViewModel: AuctionViewModel
    
    @State var offer: Offer?
    
    @StateObject var loginVm: LoginViewModel = LoginViewModel.shared
    
    @State var isPresented = false
    
    @State var showAlert = false
    
    @State var showConfirmation = false
    
    @State var seller = ""
    
    @State var showWin = false
    
    
    
    
    var body: some View {
        if !showWin {
            ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if let auctionImage = descendingPriceAuction.urlPicture {
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
                Text(descendingPriceAuction.title)
                    .font(.largeTitle)
                    .bold()
                HStack {
                    Text(descendingPriceAuction.category ?? "No category")
                    Spacer()
                    Image(systemName: "person")
                    Text("Username")
                        .bold()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                Divider()
                VStack {
                    Text(descendingPriceAuction.description ?? "No description")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                } .padding(.top)
            }
            .padding()
            HStack {
                VStack {
                    Text("\(descendingPriceAuction.currentPrice, specifier: "%.2f") €")
                        .font(.title)
                        .bold()
                    Text("Current price*")
                        .font(.callout)
                }
                
                .padding()
                
                Spacer()
                
                
            }
            Text("*Price will lower every ^[\(Int(descendingPriceAuction.timerAmount/60)) Minute](inflect: true)")
                .bold()
                .padding()
            VStack {
                
                Button {
                    if loginVm.user?.id == descendingPriceAuction.sellerId {
                        self.showConfirmation = true
                        self.showAlert = true
                    } else {
                        self.showAlert = true
                    }
                } label: {
                    if loginVm.user?.id != descendingPriceAuction.sellerId {
                        Text("Buy Now")
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
                .refreshable {
                    do {
                        try await auctionViewModel.getAllDescendingPriceAuctions()
                        self.descendingPriceAuction = auctionViewModel.descendingPriceAuctions.first {
                            $0.id == self.descendingPriceAuction.id!
                        }!
                    } catch {
                        print("Error")
                    }
                }
                .alert(isPresented: $showAlert, content: {
                    if showConfirmation {
                        Alert(title: Text("Are you sure you want to delete this auction?"),
                              message: Text("This action is permanent."),
                              primaryButton: .destructive(Text("Delete"), action: {
                            Task {
                                if try await auctionViewModel.deleteAuction(auction: descendingPriceAuction) {
                                    dismiss()
                                }
                            }
                        }),
                              secondaryButton: .default(Text("Cancel"))
                        )
                    } else {
                        Alert(title: Text("Are you sure you want to buy this item?"),
                              primaryButton: .cancel(Text("Cancel"), action: {
                            
                        }),
                              secondaryButton: .default(Text("Buy"), action: {
                            Task {
                                self.offer = try await offerViewModel.createOffer(offer: .init(offerId: nil, bidderId: loginVm.user!.id!, bidAmount: descendingPriceAuction.currentPrice, auctionId: descendingPriceAuction.id!))
                                if self.offer != nil {
                                    self.showWin = true
                                }
                            }
                        })
                        )
                    }
                })
        }
        
        } else {
            FireworksView()
                .navigationBarBackButtonHidden()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                        self.dismiss()
                    }
                }
        }
    }
}

#Preview {
    DescendingPriceAuctionDetailView(descendingPriceAuction: .init(id: nil, title: "title", description: "description", category: "category.description", sellerId: 0, urlPicture: nil, active: nil, failed: nil, currentPrice: 0, startingPrice: 100, startingDate: Date(), timer: nil, timerAmount: 60*60, reduction: 10, minimumPrice: 30), auctionViewModel: AuctionViewModel())
}
