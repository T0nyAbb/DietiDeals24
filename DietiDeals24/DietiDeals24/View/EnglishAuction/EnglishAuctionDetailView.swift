//
//  EnglishAuctionDetailView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 01/04/24.
//

import SwiftUI

struct EnglishAuctionDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var englishAuction: EnglishAuction
    
    var offerViewModel = OfferViewModel()
    
    var offerChecker = OfferChecker()
    
    var auctionViewModel: AuctionViewModel
    
    var userViewModel: UserViewModel = UserViewModel()
    
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
    
    @State var offerAmount: Int = 0
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ImageView(pictureUrl: englishAuction.urlPicture)
                .frame(width: UIScreen.main.bounds.width*0.95, height: 300)
            VStack(alignment: .leading) {
                Text(englishAuction.title)
                    .font(.largeTitle)
                    .bold()
                HStack {
                    Text(englishAuction.category ?? "No category")
                        .onAppear {
                            Task {
                                self.seller = try await userViewModel.getUserById(id: englishAuction.sellerId)
                            }
                        }
                    Spacer()
                    if loginVm.user?.id != englishAuction.sellerId {
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
                    Text(englishAuction.description ?? "No description")
                        .frame(maxWidth: .infinity)
                } .padding(.top)
            }
            .padding()
            Divider()
            VStack {
                HStack {
                    Text("Current offer:")
                        .font(.callout)
                        .onAppear {
                            offerAmount = Int(englishAuction.currentPrice)
                        }
                    Text("\(englishAuction.currentPrice, specifier: "%.2f") €")
                        .font(.title)
                        .bold()
                    Spacer()

                }
                .padding(.horizontal, 10)
                if loginVm.user?.id == englishAuction.sellerId {
                    VStack {
                        Divider()
                        HStack {
                            Text("Starting Date:")
                                .font(.caption)
                                .padding(.leading)
                            Text(englishAuction.startingDate.formatted(date: .numeric, time: .omitted))
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
                            Text(englishAuction.startingDate.formatted(date: .omitted, time: .standard))
                                .font(.title3)
                                .bold()
                            Spacer()
                            Text("\(englishAuction.startingPrice) €")
                                .font(.title)
                                .bold()
                                .padding(.trailing)
                        }
                        HStack {
                            Text("Raise amount:")
                                .font(.caption)
                                .padding(.leading)
                            Text("\(englishAuction.rise) €")
                                .font(.title3)
                                .bold()
                            Spacer()
                        }
                        HStack {
                            Text("Ends in:")
                                .font(.caption)
                                .padding(.leading)
                            Text("^[\(Int(englishAuction.timerAmount/60)) Minute](inflect: true)")
                                .font(.title3)
                                .bold()
                            Spacer()
                        }
                        
                    }.padding(.bottom)
                }
                Spacer()

            }
            VStack {
                
                Button {
                    if loginVm.user?.id == englishAuction.sellerId {
                        self.showConfirmation = true
                        self.showAlert = true
                    } else {
                        self.isPresented = true
                    }
                } label: {
                    Text(loginVm.user?.id != englishAuction.sellerId ? "Offer" : "Delete")
                        .bold()
                        .frame(width: 360, height: 45)
                        .background(loginVm.user?.id != englishAuction.sellerId ? Color.green.gradient : Color.red.gradient)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                        .padding(.top, 40)
                }
                Spacer()
                    .sheet(isPresented: $isPresented) {
                        VStack {
                            ZStack {
                                Text("\(offerAmount) €")
                                    .font(.largeTitle)
                                    .bold()
                                Stepper("Bid Amount:", onIncrement: {
                                    offerAmount += englishAuction.rise
                                            }, onDecrement: {
                                                if offerAmount > Int(englishAuction.currentPrice) {
                                                    offerAmount -= englishAuction.rise
                                                }
                                        })
                            }
                            .padding()
                            Button {
                                Task {
                                    if offerChecker.checkFixedTimeOffer(currentPrice: englishAuction.currentPrice, offerAmount: Double(offerAmount)) {
                                        do {
                                            self.offer = try await offerViewModel.createOffer(offer: .init(offerId: nil, bidderId: loginVm.user!.id!, bidAmount: Double(offerAmount), auctionId: englishAuction.id!))
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
                    .presentationDetents([.medium])
            }
            .alert(isPresented: $showAlert, content: {
                if showConfirmation {
                    Alert(title: Text("Are you sure you want to delete this auction?"),
                          message: Text("This action is permanent."),
                          primaryButton: .default(Text("Cancel")),
                          secondaryButton: .destructive(Text("Delete"), action: {
                      Task {
                          if try await auctionViewModel.deleteAuction(auction: englishAuction) {
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
                            englishAuction.currentPrice = offer!.bidAmount
                        }))
                    }
                }
            })
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EnglishAuctionDetailView(englishAuction: .init(id: 0, title: "title", description: nil, category: nil, sellerId: 0, urlPicture: nil, active: nil, failed: nil, currentPrice: 0.0, startingPrice: 10, startingDate: Date(), timer: 60*60, timerAmount: 60*60, rise: 10), auctionViewModel: AuctionViewModel())
}
