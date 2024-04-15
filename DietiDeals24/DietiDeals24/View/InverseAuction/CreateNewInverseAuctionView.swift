//
//  CreateNewInverseAuctionView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 05/04/24.
//

import SwiftUI

struct CreateNewInverseAuctionView: View {
    @State var description: String = ""
    @State var title: String = ""
    @State var category: Category = .automotive
    @State var maximumPrice: Int?
    @State var selectedDate: Date = Date().advanced(by: .days(2))
    @State private var isPresented: Bool = false
    @State var uiImage: UIImage?
    @Binding var rootIsActive: Bool
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.dismiss) var dismiss
    
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
                    TextField("Title", text: $title, prompt: Text("Title*").foregroundColor(.gray), axis: .vertical)
                        .padding(10)
                        .autocorrectionDisabled()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(description.count > 1000 ? .red : .gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                    TextField("Description", text: $description, prompt: Text("Description").foregroundColor(.gray), axis: .vertical)
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
                    TextField("Maximum Price", value: $maximumPrice, format: .currency(code: Locale.current.currency?.identifier ?? "€"), prompt: Text("Maximum Price*"))
                        .keyboardType(.decimalPad)
                        .autocorrectionDisabled()
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                    Spacer()
                    NavigationLink(destination: FixedAuctionRecapView(image: uiImage, title: title, description: description.isEmpty ? nil : description, category: category, selectedDate: selectedDate, minimumPrice: maximumPrice ?? 1, popToRoot: self.$rootIsActive)) {
                        HStack {
                            Text("Next")
                                .frame(width: 360, height: 45)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    }
                    .isDetailLink(false)
                    .id(UUID())
                    .disabled(title == "" || maximumPrice == nil)
                }
                
                .navigationTitle("Inverse Auction")
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
    CreateNewInverseAuctionView(rootIsActive: .constant(true))
}

