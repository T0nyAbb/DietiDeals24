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
    @State var nextTapped: Bool = false
    @State var next: Bool = false
    
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: selectedDate)
    }
    
    private var disableNextButton: Bool {
        return title == "" || startingPrice == nil || minimumPrice == nil
    }
    
    private var titleError: Bool {
        return title == "" && nextTapped
    }
    
    private var startingPriceError: Bool {
        return startingPrice == nil && nextTapped
    }
    
    private var minimumPriceError: Bool {
        return minimumPrice == nil && nextTapped
    }
    
    private var reductionError: Bool {
        return reductionAmount == nil && nextTapped
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
                            .padding(.top, 10)
                    } else {
                        Image(systemName: "photo")
                            .font(.system(size: 100))
                            .frame(width: 100, height: 100)
                            .padding(.top, 10)
                    }
                    if uiImage != nil {
                        Button {
                            uiImage = nil
                        } label: {
                            Text("Remove")
                                .foregroundStyle(.red)
                        }
                        .padding(.bottom, 15)
                    } else {
                        Button {
                            isPresented = true
                        } label: {
                            Text("Add picture")
                        }
                        .padding(.bottom, 15)
                    }
                    VStack(alignment: .leading) {
                        Section(header: Text("Title").bold().padding(.horizontal)) {
                            TextField("Title", text: $title, prompt: Text("Motorcycle 4-cylinder"), axis: .vertical)
                                .padding(10)
                                .autocorrectionDisabled()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(titleError ? .red : .gray, lineWidth: 2)
                                }
                                .padding(.horizontal)
                        }
                        Section(header: Text("Description").bold().padding(.horizontal)) {
                            TextField("Description", text: $description, prompt: Text("year 2013, 120 HP, 800cc, 25.000 Km"), axis: .vertical)
                                .autocorrectionDisabled()
                                .padding(15)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(description.count > 1000 ? .red : .gray, lineWidth: 2)
                                }
                                .padding(.horizontal)
                                .onChange(of: title) {
                                    nextTapped = false
                                }
                            HStack {
                                Spacer()
                                Text("\(description.count)/1000")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, -25)
                            }
                        }
                        Section(header: Text("Starting Price").bold().padding(.horizontal)) {
                            TextField("Starting Price", value: $startingPrice, format: .currency(code: Locale.current.currency?.identifier ?? "€"), prompt: Text("550,00 €"))
                                .keyboardType(.decimalPad)
                                .autocorrectionDisabled()
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(startingPriceError ? .red : .gray, lineWidth: 2)
                                }
                                .padding(.horizontal)
                                .onChange(of: startingPrice) {
                                    nextTapped = false
                                    do {
                                        next = try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: reductionAmount, startingDate: selectedDate)
                                    } catch {
                                        
                                    }
                                }
                        }
                        Section(header: Text("Minimum Price").bold().padding(.horizontal)) {
                            TextField("Minimum Price", value: $minimumPrice, format: .currency(code: Locale.current.currency?.identifier ?? "€"), prompt: Text("350,00 €"))
                                .keyboardType(.decimalPad)
                                .autocorrectionDisabled()
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(minimumPriceError ? .red : .gray, lineWidth: 2)
                                }
                                .padding(.horizontal)
                                .onChange(of: minimumPrice) {
                                    nextTapped = false
                                    do {
                                        next = try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: reductionAmount ?? 1, startingDate: selectedDate)
                                    } catch {
                                        
                                    }
                                }
                        }
                        Section(header: Text("Decrement Amount").bold().padding(.horizontal)) {
                            TextField("Decrement Amount", value: $reductionAmount, format: .currency(code: Locale.current.currency?.identifier ?? "€"), prompt: Text("1,00 €"))
                                .keyboardType(.decimalPad)
                                .autocorrectionDisabled()
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 2)
                                }
                                .padding(.horizontal)
                                .onChange(of: reductionAmount) {
                                    nextTapped = false
                                    do {
                                        next = try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: reductionAmount ?? 1, startingDate: selectedDate)
                                    } catch {
                                        
                                    }
                                }
                        }
                    }
                    Divider()
                    HStack {
                        Text("Category: ")
                            .padding()
                        Spacer()
                        Picker("Category", selection: $category) {
                            ForEach(Category.allCases, id: \.self) { category in
                                Text(category.description).tag(category)
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                    .padding(.horizontal)
                    Divider()
                        HStack {
                            Text("Starting Date:")
                                .padding()
                            Spacer()
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
                        Spacer()
                        NavigationLink(destination: DescendingPriceAuctionRecapView(image: uiImage, title: title, description: description.isEmpty ? nil : description, category: category,startingPrice: startingPrice ?? 0, selectedDate: selectedDate, minimumPrice: minimumPrice ?? 0, timerAmount: timerAmount, reductionAmount: reductionAmount ?? 1, popToRoot: self.$rootIsActive)) {
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
                        .disabled(!next || disableNextButton)
                        .onTapGesture {
                            if disableNextButton {
                                nextTapped = true
                            }
                        }
                    }
                    .navigationTitle("Descending Price Auction")
                    .navigationBarTitleDisplayMode(.inline)
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
