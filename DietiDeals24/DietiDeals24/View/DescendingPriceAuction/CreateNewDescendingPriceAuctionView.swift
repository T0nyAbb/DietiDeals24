//
//  CreateNewDescendingPriceAuctionView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 20/03/24.
//

import SwiftUI

struct CreateNewDescendingPriceAuctionView: View {
    @State var description: String = ""
    @State var title: String = ""
    @State var category: Category = .automotive
    @State var startingPrice: Int?
    @State var selectedDate: Date = Date().advanced(by: .days(2))
    @State var minimumPrice: Int?
    @State var timerAmount: Int = 60
    @State var reductionAmount: Int?
    @State private var isPresented: Bool = false
    @State var uiImage: UIImage?
    @Binding var rootIsActive: Bool
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.dismiss) private var dismiss
    var descendingPriceChecker = DescendingPriceChecker()
    @State var next: Bool = false
    
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        if rootIsActive {
            ScrollView(.vertical, showsIndicators: false) {
                
                
                VStack {
                    if let image = uiImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 125, height: 125)
                            .padding(.top, 30)
                    } else {
                        Image(systemName: "photo")
                            .font(.system(size: 100))
                            .frame(width: 100, height: 100)
                            .padding(.top, 30)
                    }
                    Button {
                        isPresented = true
                    } label: {
                        Text("Add picture")
                    }
                    .padding(.vertical, 25)
                    TextField("Title", text: $title, prompt: Text("Title*"), axis: .vertical)
                        .padding(10)
                        .autocorrectionDisabled()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(description.count > 1000 ? .red : .gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                    TextField("Description", text: $description, prompt: Text("Description"), axis: .vertical)
                        .autocorrectionDisabled()
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(description.count > 1000 ? .red : .gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                    HStack {
                        Spacer()
                        Text("\(description.count)/1000")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 30)
                            .padding(.top, -7)
                    }
                    Divider()
                    HStack {
                        Text("Category: ")
                            .padding()
                            .padding(.horizontal, 10)
                        Picker("Category", selection: $category) {
                            ForEach(Category.allCases, id: \.self) { category in
                                Text(category.description).tag(category)
                            }
                        }
                        .pickerStyle(.automatic)
                        Spacer()
                    }
                    TextField("Starting Price", value: $startingPrice, format: .currency(code: Locale.current.currency?.identifier ?? "€"), prompt: Text("Starting price*"))
                        .keyboardType(.decimalPad)
                        .autocorrectionDisabled()
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                        .onChange(of: startingPrice) {
                            do {
                                next = try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: reductionAmount, startingDate: selectedDate)
                            } catch {
                                
                            }
                        }
                    HStack {
                        Text("Starting Date:")
                            .padding()
                        
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                        DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                            .padding(.horizontal)
                            .onChange(of: selectedDate) {
                                do {
                                    next = try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice ?? 1, minimumPrice: minimumPrice, decrementAmount: reductionAmount ?? 1, startingDate: selectedDate)
                                } catch {
                                    
                                }
                            }
                    }
                    TextField("Starting Price", value: $minimumPrice, format: .currency(code: Locale.current.currency?.identifier ?? "€"), prompt: Text("Minimum selling price*"))
                        .keyboardType(.decimalPad)
                        .autocorrectionDisabled()
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                        .onChange(of: minimumPrice) {
                            do {
                                next = try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: reductionAmount ?? 1, startingDate: selectedDate)
                            } catch {
                                
                            }
                        }
                    Divider()
                    HStack {
                        Text("Timer: ")
                            .padding()
                            .padding(.horizontal, 10)
                        Picker("Timer", selection: $timerAmount) {
                            ForEach(1...120, id: \.self) {
                                Text("^[\($0) Minute](inflect: true)")
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 100)
                        Spacer()
                        
                    }
                    Divider()
                    TextField("Decrement Amount", value: $reductionAmount, format: .currency(code: Locale.current.currency?.identifier ?? "€"), prompt: Text("Decrement Amount (Default 1€)"))
                        .keyboardType(.decimalPad)
                        .autocorrectionDisabled()
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                        .onChange(of: reductionAmount) {
                            do {
                                next = try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: reductionAmount ?? 1, startingDate: selectedDate)
                            } catch {
                                
                            }
                        }
                    Spacer()
                    NavigationLink(destination: DescendingPriceAuctionRecapView(image: uiImage, title: title, description: description.isEmpty ? nil : description, category: category,startingPrice: startingPrice!, selectedDate: selectedDate, minimumPrice: minimumPrice ?? 0, timerAmount: timerAmount, reductionAmount: reductionAmount ?? 1, popToRoot: self.$rootIsActive)) {
                        HStack {
                            Text("Next")
                                .frame(width: 360, height: 45)
                                .background(next ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }.padding(.top, 100)
                    }
                    .isDetailLink(false)
                    .id(UUID())
                    .disabled(!next || title == "")
                }
                .navigationTitle("Descending Price Auction")
                .sheet(isPresented: $isPresented, content: {
                    ImagePicker(uiImage: $uiImage, isPresenting: $isPresented, sourceType: $sourceType)
                })
            }
            .scrollDismissesKeyboard(.immediately)
        }
        else {
            Text("")
                .navigationBarBackButtonHidden()
                .onAppear {
                    dismiss()
                }
        }
    }
}

#Preview {
    CreateNewDescendingPriceAuctionView(rootIsActive: .constant(true))
}
