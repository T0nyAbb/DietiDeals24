//
//  InverseAuctionDetailView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 05/04/24.
//

import SwiftUI

struct InverseAuctionDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var inverseAuction: InverseAuction
    
    var offerViewModel = OfferViewModel()
    
    var offerChecker = OfferChecker()
    
    var auctionViewModel: AuctionViewModel
    
    @State var offer: Offer?
    
    @State var user: User?
    
    @State var seller: User?
    
    @StateObject var loginVm: LoginViewModel = LoginViewModel.shared
    
    
    @State var isPresented: Bool = false
    
    @State var showAlert: Bool = false
    
    @State var showConfirmation: Bool = false
    
    @State var auctionNotActiveError: Bool = false
    
    @State var offerAlreadyMadeError: Bool = false
    
    @State var offerError: Bool = false
    
    @State var offerAmount: Double = 0.0
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ImageView(pictureUrl: inverseAuction.urlPicture)
                .frame(width: UIScreen.main.bounds.width*0.95, height: 300)
            VStack(alignment: .leading) {
                Text(inverseAuction.title)
                    .font(.largeTitle)
                    .bold()
                HStack {
                    Text(inverseAuction.category ?? "No category")
                    Spacer()
                    if loginVm.user?.id != inverseAuction.sellerId {
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
                    Text(inverseAuction.description ?? "No description")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                } .padding(.top)
            }
            .padding()
            Divider()
            VStack {
                HStack {
                    Text("Lowest offer:")
                        .font(.caption)
                    Text(inverseAuction.currentPrice > 0 ? "\(inverseAuction.currentPrice, specifier: "%.2f") €" : "No offers")
                        .font(.title)
                        .bold()
                    Spacer()
                    
                }
                .padding(.horizontal, 10)
                if loginVm.user?.id == inverseAuction.sellerId {
                    VStack {
                        Divider()
                        HStack {
                            Text("Exipry Date:")
                                .font(.caption)
                                .padding(.leading)
                            Text(inverseAuction.expiryDate.formatted(date: .numeric, time: .omitted))
                                .font(.title3)
                                .bold()
                            Spacer()
                            Text("Maximum budget")
                                .font(.caption)
                                .padding(.trailing)
                        }
                        HStack {
                            Text("Expiry Time:")
                                .font(.caption)
                                .padding(.leading)
                            Text(inverseAuction.expiryDate.formatted(date: .omitted, time: .standard))
                                .font(.title3)
                                .bold()
                            Spacer()
                            Text("\(inverseAuction.startingPrice) €")
                                .font(.title)
                                .bold()
                                .padding(.trailing)
                        }
                        
                    }.padding(.bottom)
                }
            }
            VStack {
                
                Button {
                    if loginVm.user?.id == inverseAuction.sellerId {
                        self.showConfirmation = true
                        self.showAlert = true
                    } else {
                        self.isPresented = true
                    }
                } label: {
                    Text(loginVm.user?.id != inverseAuction.sellerId ? "Offer" : "Delete")
                        .bold()
                        .frame(width: 360, height: 45)
                        .background(loginVm.user?.id != inverseAuction.sellerId ? Color.green.gradient : Color.red.gradient)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                        .padding(.top, 40)
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
                                    if offerChecker.checkInverseAuctionOffer(currentPrice: inverseAuction.currentPrice, offerAmount: offerAmount) {
                                        do {
                                        self.offer = try await offerViewModel.createOffer(offer: .init(offerId: nil, bidderId: loginVm.user!.id!, bidAmount: offerAmount, auctionId: inverseAuction.id!))
                                        } catch UserError.auctionNotActive {
                                            print("Auction not active")
                                            self.offerError = true
                                            self.auctionNotActiveError = true
                                            isPresented = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                                self.showAlert = true
                                            }
                                        } catch UserError.invalidOffer {
                                            print("Invalid offer")
                                            self.offerError = true
                                            self.offerAlreadyMadeError = true
                                            isPresented = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                                self.showAlert = true
                                            }
                                        }
                                    } else {
                                        print("Invalid offer")
                                        self.offerError = true
                                        self.offerAlreadyMadeError = true
                                        isPresented = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                            self.showAlert = true
                                        }

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
                    }
                    .presentationDetents([.medium, .large])
            }
            .alert(isPresented: $showAlert, content: {
                if showConfirmation {
                    Alert(title: Text("Are you sure you want to delete this auction?"),
                          message: Text("This action is permanent."),
                          primaryButton: .default(Text("Cancel")),
                          secondaryButton: .destructive(Text("Delete"), action: {
                      Task {
                          if try await auctionViewModel.deleteAuction(auction: inverseAuction) {
                              dismiss()
                          }
                      }
                  })
                    )
                } else {
                    if offerError {
                        if auctionNotActiveError {
                            Alert(title: Text("Error"),
                                  message: Text("The auction is not active."),
                                  dismissButton: .default(Text("Ok"), action: {
                                auctionNotActiveError = false
                                offerError = false
                            })
                            )
                        } else {
                            Alert(title: Text("Error"),
                                  message: Text("An offer of \(offerAmount) € was already made for this auction"),
                                  dismissButton: .default(Text("Ok"), action: {
                                offerAlreadyMadeError = false
                                offerError = false
                            })
                            )
                        }
                        
                    } else {
                        Alert(title: Text("Bid successfuly made!"), dismissButton: .default(Text("Ok"), action: {
                            inverseAuction.currentPrice = offer!.bidAmount
                        }))
                    }
                }
            })
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FixedTimeAuctionDetailView(fixedTimeAuction: .init(id: 0, title: "Auction title", description: "Auction description", category: "Auction category", sellerId: 0, urlPicture: nil, active: nil, failed: nil, currentPrice: 20, minimumPrice: 30, expiryDate: Date().advanced(by: .hours(2))), auctionViewModel: AuctionViewModel())
}
