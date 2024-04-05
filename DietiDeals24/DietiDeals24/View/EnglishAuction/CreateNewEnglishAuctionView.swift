//
//  CreateNewEnglishAuctionView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 20/03/24.
//

import SwiftUI

struct CreateNewEnglishAuctionView: View {
    @State var description: String = ""
    @State var title: String = ""
    @State var category: Category = .automotive
    @State var startingPrice: Int?
    @State var timerAmount: Int = 60
    @State var raiseAmount: Int?
    @State private var isPresented: Bool = false
    @State var uiImage: UIImage?
    @Binding var rootIsActive: Bool
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.dismiss) private var dismiss
    @State var nextDisabled = true
    
    

    
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
                        .padding()
                        .onChange(of: startingPrice) {
                            nextDisabled = startingPrice == nil
                        }
                    Divider()
                    HStack {
                        Text("Bid interval: ")
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
                    TextField("Bid raise threshold", value: $raiseAmount, format: .currency(code: Locale.current.currency?.identifier ?? "€"), prompt: Text("Bid raise threshold (Default 10 €)"))
                        .keyboardType(.decimalPad)
                        .autocorrectionDisabled()
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                    Spacer()
                    NavigationLink(destination: EnglishAuctionRecapView(title: title, description: description, category: category, startingPrice: startingPrice ?? 0, timerAmount: timerAmount, raiseAmount: raiseAmount ?? 10, popToRoot: self.$rootIsActive)) {
                        HStack {
                            Text("Next")
                                .frame(width: 360, height: 45)
                                .background(title != "" ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }.padding(.top, 100)
                    }
                    .isDetailLink(false)
                    .id(UUID())
                    .disabled(title == "" || nextDisabled)
                }
                .navigationTitle("English Auction")
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
    CreateNewEnglishAuctionView(rootIsActive: .constant(true))
}
