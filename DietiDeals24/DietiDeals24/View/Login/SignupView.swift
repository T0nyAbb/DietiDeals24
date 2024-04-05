//
//  SignupView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 09/03/24.
//

import SwiftUI

struct SignupView: View {
    
    @StateObject var loginVm = LoginViewModel.shared
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var bio: String = ""
    @State private var characterCount = 0
    @State private var webSite: String = ""
    @State private var social: String = ""
    @State private var geographicArea: String = ""
    @State private var profilePicture: String = ""
    @State private var iban: String = ""
    @State private var vatNumber: String = ""
    @State private var nationalInsuranceNumber: String = ""
    @State private var showPassword: Bool = false
    @State var user: User?
    @State var token: Token?
    @State var animateButton = false
    @State var showAlert = false
    @State var showError = false
    @State var showConfirmation = false
    @Environment(\.dismiss) var dismiss
    var fieldChecker = FieldChecker()
    
    
    
    private var isSignInButtonDisabled: Bool {
        do { return try !fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban)
        } catch {
            return true
        }
    }
    
    var body: some View {
            ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 15) {
                Spacer()
                Section(header: Text("General info").bold().padding(.horizontal)) {
                    TextField("First Name",
                              text: $firstName ,
                              prompt: Text("First Name*").foregroundColor(.gray)
                              
                    )
                    .autocorrectionDisabled()
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 2)
                    }
                .padding(.horizontal)
                }
                TextField("Last Name",
                          text: $lastName ,
                          prompt: Text("Last Name*").foregroundColor(.gray)
                )
                .autocorrectionDisabled()
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 2)
                }
                .padding(.horizontal)
                
                TextField("Email",
                          text: $username ,
                          prompt: Text("Email*").foregroundColor(.gray)
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 2)
                }
                .padding(.horizontal)
                
                HStack {
                    Group {
                        if showPassword {
                            TextField("Password", // how to create a secure text field
                                      text: $password,
                                      prompt: Text("Password*").foregroundColor(.gray)) // How to change the color of the TextField Placeholder
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        } else {
                            SecureField("Password", // how to create a secure text field
                                        text: $password,
                                        prompt: Text("Password*").foregroundColor(.gray)) // How to change the color of the TextField Placeholder
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        }
                    }
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 2) // How to add rounded corner to a TextField and change it colour
                    }
                    
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .foregroundColor(.blue) // how to change image based in a State variable
                    }
                    
                }.padding(.horizontal)
                if showPassword {
                    TextField("Confirm Password",
                              text: $confirmPassword,
                              prompt: Text("Confirm Password*").foregroundColor(.gray))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 2)
                    }
                    .padding(.horizontal)
                } else {
                    SecureField("Confirm Password",
                                text: $confirmPassword,
                                prompt: Text("Confirm Password*").foregroundColor(.gray))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 2)
                    }
                    .padding(.horizontal)
                }
                HStack {
                    Text("At least 5 characters and one number")
                        .bold()
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 30)
                        .padding(.top, -10)
                }
                TextField("Bio", text: $bio, prompt: Text("Bio").foregroundColor(.gray), axis: .vertical)
                    .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(bio.count > 1000 ? .red : .gray, lineWidth: 2)
                }
                .padding(.horizontal)
                HStack {
                    Spacer()
                    Text("\(bio.count)/1000")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 30)
                        .padding(.top, -10)
                }
                TextField("Website", text: $webSite, prompt: Text("Your Website").foregroundColor(.gray))
                    .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 2)
                }
                .padding(.horizontal)
                
                TextField("Social", text: $social, prompt: Text("Your Social Network").foregroundColor(.gray))
                    .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 2)
                }
                .padding(.horizontal)
                TextField("Geographic Area", text: $geographicArea, prompt: Text("Geographic Area").foregroundColor(.gray))
                    .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 2)
                }
                .padding(.horizontal)
                Divider()
                Section(header: Text("Billing info").bold().padding(.horizontal)) {
                    TextField("Iban", text: $iban, prompt: Text("IBAN*").foregroundColor(.gray))
                        .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 2)
                    }
                .padding(.horizontal)
                    HStack {
                        Text("2 letters at the beginning then only digits\n Length between 15 and 30 characters")
                            .bold()
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .padding(.horizontal, 30)
                            .padding(.top, -10)
                    }
                    Divider()
                }
                Section(header: Text("Selling info").bold().padding(.horizontal)) {
                    TextField("VAT Number", text: $vatNumber, prompt: Text("VAT Number**").foregroundColor(.gray))
                        .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 2)
                    }
                .padding(.horizontal)
                }
                TextField("National Insurance Number", text: $nationalInsuranceNumber, prompt: Text("National Insurance Number**").foregroundColor(.gray))
                    .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 2)
                }
                .padding(.horizontal)
                Divider()
                Text("(* Required | ** Required for selling)")
                    .foregroundStyle(.gray)
                    .bold()
                    .padding(.horizontal)
                Spacer()
                
                Button {
                    do { 
                        self.showError = try !fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban)
                    } catch {
                        self.showError = true
                    }
                    Task {
                        do {
                            token = try await loginVm.signUp(user: .init(id: nil, firstName: self.firstName, lastName: self.lastName, username: self.username, password: self.password, bio: self.bio, website: self.webSite, social: self.social, geographicArea: self.geographicArea, google: nil, facebook: nil, apple: nil, profilePicture: nil, iban: self.iban, vatNumber: self.vatNumber, nationalInsuranceNumber: self.nationalInsuranceNumber))
                            if token != nil {
                                showConfirmation = true
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity) // how to make a button fill all the space available horizontaly
                .background(
                    isSignInButtonDisabled ? // how to add a gradient to a button in SwiftUI if the button is disabled
                    LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .hueRotation(Angle(degrees: 0)):
                        LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .hueRotation(.degrees(animateButton ? 45 : -45))
                    
                )
                .onAppear {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        animateButton.toggle()
                    }
                }
                .cornerRadius(20)
                .disabled(isSignInButtonDisabled) // how to disable while some condition is applied
                .padding()
            }
            .navigationTitle("Sign Up")
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text("Some fields are not valid"), dismissButton: .default(Text("Ok")))
            }
            .alert(isPresented: $showConfirmation) {
                Alert(title: Text("Success"), message: Text("Account successfully registered!"), dismissButton: .default(Text("Ok"), action: {dismiss()}))
            }
            .onDisappear {
                firstName = ""
                lastName = ""
                username = ""
                password = ""
                confirmPassword = ""
                bio = ""
                webSite = ""
                social = ""
                geographicArea = ""
                iban = ""
                vatNumber = ""
                nationalInsuranceNumber = ""
            }
            
        }
        
    
    }
}

#Preview {
    SignupView()
}
