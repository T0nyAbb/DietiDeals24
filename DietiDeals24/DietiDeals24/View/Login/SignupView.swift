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
    @State private var geographicArea: String = "Italy"
    @State private var profilePicture: String = ""
    @State private var iban: String = ""
    @State private var vatNumber: String = ""
    @State private var nationalInsuranceNumber: String = ""
    @State private var showPassword: Bool = false
    @State private var countryList: [String] = Locale.Region.isoRegions.compactMap { Locale.current.localizedString(forRegionCode: $0.identifier) }
    @State var user: User?
    @State var token: Token?
    @State var animateButton = false
    @State var showAlert = false
    @State var showError = false
    @State var showConfirmation = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.locale) var locale
    var fieldChecker: FieldChecker = FieldChecker()
    
    
    
    private var isSignInButtonDisabled: Bool {
        do { return try !fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban)
        } catch {
            return true
        }
    }
    
    private var isPasswordValid: Bool {
        let numberRegex  = ".*[0-9]+.*"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", numberRegex)
        if(password.count < 5) {
            return false
        }
        if(!passwordPredicate.evaluate(with: password)) {
            return false
        }
        if(password != confirmPassword) {
            return false
        }
        return true
    }
    
    private var isPasswordEmpty: Bool {
        return password == "" && confirmPassword == ""
    }
    
    private var checkPasswordField: Bool {
        return isPasswordEmpty || isPasswordValid
    }
    
    private var checkIbanField: Bool {
        return iban.isEmpty || isIbanValid
    }
    
    private var isIbanValid: Bool {
        let ibanRegex = #"^[a-zA-Z]{2}\d+$"#
        let ibanPredicate = NSPredicate(format: "SELF MATCHES %@", ibanRegex)
        if(iban.count < 15 || iban.count > 30) {
            return false
        }
        if(!ibanPredicate.evaluate(with: iban)) {
            return false
        }
        return true
    }
    
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
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
                            TextField("Password",
                                      text: $password,
                                      prompt: Text("Password*").foregroundColor(.gray))
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        } else {
                            SecureField("Password",
                                        text: $password,
                                        prompt: Text("Password*").foregroundColor(.gray))
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        }
                    }
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 2)
                    }
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .foregroundColor(.blue)
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
                            .stroke(checkPasswordField ? .gray : .red, lineWidth: 2)
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
                            .stroke(checkPasswordField ? .gray : .red, lineWidth: 2)
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
                    .padding(20)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(bio.count > 1000 ? .red : .gray, lineWidth: 2)
                    }
                    .padding(.horizontal)
                HStack {
                    Spacer()
                    Text("\(bio.count)/1000")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 30)
                        .padding(.vertical, -35)
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
                Divider()
                HStack {
                    Text("Geographic Area: ")
                        .padding()
                    Spacer()
                    Picker("Geographic Area", selection: $geographicArea) {
                        ForEach(countryList, id:\.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.automatic)
                }
                .padding(.horizontal)
                Divider()
                Section(header: Text("Billing info").bold().padding(.horizontal)) {
                    TextField("Iban", text: $iban, prompt: Text("IBAN*").foregroundColor(.gray))
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(checkIbanField ? .gray : .red, lineWidth: 2)
                        }
                        .padding(.horizontal)
                    HStack {
                        Text("2 letters at the beginning then only digits.\n Length must be between 15 and 30 characters")
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
                        self.showAlert = true
                    }
                    Task {
                        do {
                            token = try await loginVm.signUp(user: .init(id: nil, firstName: self.firstName, lastName: self.lastName, username: self.username, password: self.password, bio: self.bio, website: self.webSite, social: self.social, geographicArea: self.geographicArea, google: nil, facebook: nil, apple: nil, profilePicture: nil, iban: self.iban, vatNumber: self.vatNumber, nationalInsuranceNumber: self.nationalInsuranceNumber))
                            if token != nil {
                                showConfirmation = true
                                showAlert = true
                            }
                        } catch {
                            print(error.localizedDescription)
                            showError = true
                            showAlert = true
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(
                            isSignInButtonDisabled ?
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
                        .disabled(isSignInButtonDisabled)
                        .padding()
                }
            }
            .navigationTitle("Sign Up")
            .alert(isPresented: $showAlert) {
                if showError {
                    Alert(title: Text("Error"), message: Text("Some fields are not valid"), dismissButton: .default(Text("Ok"), action: {
                        showError = false
                        showAlert = false
                    }))
                } else  {
                    Alert(title: Text("Success"), message: Text("Account successfully created!"), dismissButton: .default(Text("Ok"), action: {
                        showConfirmation = false
                        showAlert = false
                        dismiss()
                    }))
                }
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
        .scrollDismissesKeyboard(.immediately)
    }
}

#Preview {
    SignupView()
}
