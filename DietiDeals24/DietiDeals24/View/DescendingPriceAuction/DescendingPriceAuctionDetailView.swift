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
    
    var userViewModel: UserViewModel = UserViewModel()
    
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
                    .frame(width: UIScreen.main.bounds.width*0.95, height: 300)
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
                                    .foregroundStyle(.blue)
                                Text("\(seller?.firstName ?? "") \(seller?.lastName ?? "")")
                                    .foregroundStyle(.blue)
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
            Divider()
            VStack {
                HStack {
                    Text("Current price:")
                        .font(.callout)
                    Text("\(descendingPriceAuction.currentPrice, specifier: "%.2f") €*")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.bottom)
                HStack {
                    Text("*Price will lower by \(descendingPriceAuction.reduction) € every ^[\(Int(descendingPriceAuction.timerAmount/60)) Minute](inflect: true)")
                        .font(.caption)
                        .bold()
                    Spacer()
                }.padding(.horizontal, 10)
                if loginVm.user?.id == descendingPriceAuction.sellerId {
                    VStack {
                        Divider()
                        HStack {
                            Text("Starting Date:")
                                .font(.caption)
                                .padding(.leading)
                            Text(descendingPriceAuction.startingDate.formatted(date: .numeric, time: .omitted))
                                .font(.title3)
                                .bold()
                            Spacer()
                            Text("Minimum selling price")
                                .font(.caption)
                                .padding(.trailing)
                        }
                        HStack {
                            Text("Starting Time:")
                                .font(.caption)
                                .padding(.leading)
                            Text(descendingPriceAuction.startingDate.formatted(date: .omitted, time: .standard))
                                .font(.title3)
                                .bold()
                            Spacer()
                            Text("\(descendingPriceAuction.startingPrice) €")
                                .font(.title)
                                .bold()
                                .padding(.trailing)
                        }
                        
                    }.padding(.bottom)
                }
                Spacer()
            }

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
                        print(error)
                    }
                }
                .alert(isPresented: $showAlert, content: {
                    if showConfirmation {
                        Alert(title: Text("Are you sure you want to delete this auction?"),
                              message: Text("This action is permanent."),
                              primaryButton: .default(Text("Cancel")),
                              secondaryButton: .destructive(Text("Delete"), action: {
                          Task {
                              if try await auctionViewModel.deleteAuction(auction: descendingPriceAuction) {
                                  dismiss()
                              }
                          }
                      })
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
            .task {
            do {
                self.seller = try await userViewModel.getUserById(id: descendingPriceAuction.sellerId)
            } catch {
                print(error)
            }
        }
            .navigationBarTitleDisplayMode(.inline)
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
