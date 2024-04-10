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
    
    @State var seller: User?
    
    @StateObject var loginVm: LoginViewModel = LoginViewModel.shared
    
    @State var isPresented = false
    
    @State var showAlert = false
    
    @State var showConfirmation = false

    @State var showWin = false
    
    
    
    
    var body: some View {
        if !showWin {
            ScrollView(.vertical, showsIndicators: false) {
                ImageView(pictureUrl: descendingPriceAuction.urlPicture)
                    .frame(width: 300, height: 300)
            VStack(alignment: .leading) {
                Text(descendingPriceAuction.title)
                    .font(.largeTitle)
                    .bold()
                HStack {
                    Text(descendingPriceAuction.category ?? "No category")
                    Spacer()
                    if loginVm.user?.id != descendingPriceAuction.sellerId {
                        NavigationLink(destination: UserProfileView(user: seller)) {
                            HStack {
                                Image(systemName: "person")
                                Text("\(seller?.firstName ?? "") \(seller?.lastName ?? "")")
                                    .bold()
                            }
                        }
                        .isDetailLink(false)
                        .id(UUID())
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                Divider()
                VStack {
                    Text(descendingPriceAuction.description ?? "No Description")
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
                Text("*Price will lower by \(descendingPriceAuction.reduction) € every ^[\(Int(descendingPriceAuction.timerAmount/60)) Minute](inflect: true)")
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
                        Text(loginVm.user?.id != descendingPriceAuction.sellerId ? "Buy Now" : "Delete")
                            .bold()
                            .frame(width: 360, height: 45)
                            .background(loginVm.user?.id != descendingPriceAuction.sellerId ? Color.green.gradient : Color.red.gradient)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                            .padding(.top, 40)
                }
            }
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
            ZStack {
                FireworksView(config: .init(intensity: .high))
                Text("You Won!")
                    .font(.largeTitle)
                    .bold()
                    .fontDesign(.monospaced)
                    .scaleEffect(2)
                    
            }
                .navigationBarBackButtonHidden()
                .onTapGesture {
                    self.dismiss()
                }
        }
    }
}

#Preview {
    DescendingPriceAuctionDetailView(descendingPriceAuction: .init(id: nil, title: "title", description: "description", category: "category.description", sellerId: 0, urlPicture: nil, active: nil, failed: nil, currentPrice: 0, startingPrice: 100, startingDate: Date(), timer: nil, timerAmount: 60*60, reduction: 10, minimumPrice: 30), auctionViewModel: AuctionViewModel())
}
