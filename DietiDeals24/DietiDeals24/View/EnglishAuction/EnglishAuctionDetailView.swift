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
    
    @State var offer: Offer?
    
    @State var user: User?
    
    @StateObject var loginVm: LoginViewModel = LoginViewModel.shared
    
    
    @State var isPresented = false
    
    @State var showAlert = false
    
    @State var showConfirmation = false
    
    @State var auctionNotActiveError = false
    
    @State var offerAlreadyMadeError = false
    
    @State var offerError = false
    
    @State var offerAmount: Int = 0
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            AuctionImageView(pictureUrl: englishAuction.urlPicture)
                .frame(width: 300, height: 300)
            VStack(alignment: .leading) {
                Text(englishAuction.title)
                    .font(.largeTitle)
                    .bold()
                HStack {
                    Text(englishAuction.category ?? "No category")
                    Spacer()
                    Image(systemName: "person")
                    Text("Username")
                        .bold()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                Divider()
                VStack {
                    Text(englishAuction.description ?? "No description")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                } .padding(.top)
            }
            .padding()
            HStack {
                VStack {
                    Text("\(englishAuction.currentPrice, specifier: "%.2f") €")
                        .font(.title)
                        .bold()
                    Text("Current offer")
                        .font(.callout)
                        .onAppear {
                            offerAmount = Int(englishAuction.currentPrice)
                        }
                }
                .padding()
                Spacer()
                VStack {
                    Text("\(englishAuction.startingPrice, specifier: "%.2f") €")
                        .font(.title2)
                        .bold()
                    Text("Starting price")
                        .font(.callout)
                }
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
                          primaryButton: .destructive(Text("Delete"), action: {
                        Task {
                            if try await auctionViewModel.deleteAuction(auction: englishAuction) {
                                dismiss()
                            }
                        }
                    }),
                          secondaryButton: .default(Text("Cancel"))
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
    }
}

#Preview {
    EnglishAuctionDetailView(englishAuction: .init(id: nil, title: "title", description: nil, category: nil, sellerId: 0, urlPicture: nil, active: nil, failed: nil, currentPrice: 0.0, startingPrice: 10, startingDate: Date(), timer: 60*60, timerAmount: 60*60, rise: 10), auctionViewModel: AuctionViewModel())
}
