//
//  CreateNewFixedTimeAuctionView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 20/03/24.
//

import SwiftUI

struct CreateNewFixedTimeAuctionView: View {
    
    @State var description: String = ""
    @State var title: String = ""
    @State var category: Category = .automotive
    @State var minimumPrice: Int?
    @State var selectedDate: Date = Date().advanced(by: .days(2))
    @State private var isPresented: Bool = false
    @State var uiImage: UIImage?
    @Binding var rootIsActive: Bool
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var nextTapped: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: selectedDate)
    }
    
    private var disableNextButton: Bool {
        return title == "" || minimumPrice == nil
    }
    
    private var titleError: Bool {
        return title == "" && nextTapped
    }
    
    private var priceError: Bool {
        return minimumPrice == nil && nextTapped
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
                        Section(header: Text("Minimum Price").bold().padding(.horizontal)) {
                            TextField("Minimum Price", value: $minimumPrice, format: .currency(code: Locale.current.currency?.identifier ?? "€"), prompt: Text("850,00 €"))
                                .keyboardType(.decimalPad)
                                .autocorrectionDisabled()
                                .padding(10)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(priceError ? .red : .gray, lineWidth: 2)
                                }
                                .padding(.horizontal)
                                .onChange(of: minimumPrice) {
                                    nextTapped = false
                                }
                        }
                    }
                    .padding(.bottom)
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
                        Text("Expiry Date:")
                            .padding()
                        
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                            .padding(.horizontal)
                    }
                    Divider()

                    Spacer()
                    NavigationLink(destination: FixedAuctionRecapView(image: uiImage, title: title, description: description.isEmpty ? nil : description, category: category, selectedDate: selectedDate, minimumPrice: minimumPrice ?? 1, popToRoot: self.$rootIsActive)) {
                        HStack {
                            Text("Next")
                                .frame(width: 360, height: 45)
                                .background(disableNextButton ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .padding()
                        }
                    }

                    .isDetailLink(false)
                    .id(UUID())
                    .disabled(disableNextButton)
                    .onTapGesture {
                        if disableNextButton {
                            nextTapped = true
                        }
                    }
                }
                .navigationTitle("Fixed Time Auction")
                .sheet(isPresented: $isPresented, content: {
                    ImagePicker(uiImage: $uiImage, isPresenting: $isPresented, sourceType: $sourceType)
                })
            }
            .scrollDismissesKeyboard(.immediately)
        } else {
            Text("")
                .navigationBarBackButtonHidden()
                .onAppear {
                    dismiss()
                }
        }
    }
}

#Preview {
    CreateNewFixedTimeAuctionView(rootIsActive: .constant(true))
}
