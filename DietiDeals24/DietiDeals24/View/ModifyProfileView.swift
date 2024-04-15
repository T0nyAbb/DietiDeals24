//
//  ModifyProfileView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 06/04/24.
//

import SwiftUI

struct ModifyProfileView: View {
    @State var user: User
    var userViewModel: UserViewModel
    @State private var firstName: String
    @State private var lastName: String
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var bio: String
    @State private var webSite: String
    @State private var social: String
    @State private var geographicArea: String
    @State private var iban: String
    @State private var vatNumber: String
    @State private var nationalInsuranceNumber: String
    @State private var showPassword: Bool = false
    @State private var showAlert: Bool = false
    @State private var showError: Bool = false
    @State private var showConfirmation: Bool = false
    @State private var countryList: [String] = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
    @Environment(\.dismiss) var dismiss
    @Binding var changed: Bool

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
    
    private var buttonDisabled: Bool {
        if isPasswordEmpty && iban.isEmpty {
            return false
        }
        
        if isPasswordEmpty && isIbanValid {
            return false
        }
        
        if isPasswordValid && iban.isEmpty {
            return false
        }
        
        if isPasswordValid && isIbanValid {
            return false
        }
        
        return true
    }
    
    private var isSocialProviderAccount: Bool {
        return user.apple != nil || user.google != nil || user.facebook != nil
    }
    
    
    init(user: User, userViewModel: UserViewModel, changed: Binding<Bool>) {
        self.user = user
        self.firstName = user.firstName ?? ""
        self.lastName = user.lastName ?? ""
        self.bio = user.bio ?? ""
        self.webSite = user.website ?? ""
        self.social = user.social ?? ""
        self.geographicArea = user.geographicArea ?? ""
        self.iban = user.iban ?? ""
        self.vatNumber = user.vatNumber ?? ""
        self.nationalInsuranceNumber = user.nationalInsuranceNumber ?? ""
        self.userViewModel = userViewModel
        self._changed = changed
    }
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                Spacer()
                    TextField("First Name",
                              text: $firstName ,
                              prompt: Text(user.firstName ?? "First Name").foregroundColor(.gray)
                              
                    )
                    .autocorrectionDisabled()
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 2)
                    }
                    .padding(.horizontal)
                    TextField("Last Name",
                              text: $lastName ,
                              prompt: Text(user.lastName ?? "Last Name").foregroundColor(.gray)
                              
                    )
                    .autocorrectionDisabled()
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 2)
                    }
                    .padding(.horizontal)
                if !isSocialProviderAccount {
                    HStack {
                        Group {
                            if showPassword {
                                TextField("Password",
                                          text: $password,
                                          prompt: Text("Password").foregroundColor(.gray))
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                            } else {
                                SecureField("Password",
                                            text: $password,
                                            prompt: Text("Password").foregroundColor(.gray))
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                            }
                        }
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(checkPasswordField ? .gray : .red, lineWidth: 2)
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
                                  prompt: Text("Confirm Password").foregroundColor(.gray))
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
                                    prompt: Text("Confirm Password").foregroundColor(.gray))
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
                }
                TextField("Bio", text: $bio, prompt: Text(user.bio ?? "Bio").foregroundColor(.gray), axis: .vertical)
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
                TextField("Website", text: $webSite, prompt: Text(user.website ?? "Your Website").foregroundColor(.gray))
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                TextField("Social", text: $social, prompt: Text(user.social ?? "Your Social Network").foregroundColor(.gray))
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 2)
                    }
                    .padding(.horizontal)
                HStack {
                    Text("Geographic Area: ")
                        .padding()
                        .padding(.horizontal, 10)
                    Picker("Timer", selection: $geographicArea) {
                        ForEach(countryList, id:\.self) { country in
                            Text(country)
                        }
                    }
                    .pickerStyle(.automatic)
                    .frame(height: 100)
                    Spacer()
                    
                }
                Divider()
                Section(header: Text("Billing info").bold().padding(.horizontal)) {
                    TextField("Iban", text: $iban, prompt: Text(user.iban ?? "IBAN").foregroundColor(.gray))
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(checkIbanField ? .gray : .red, lineWidth: 2)
                        }
                        .padding(.horizontal)
                    HStack {
                        Text("2 letters at the beginning then only digits.\n Length between 15 and 30 characters.")
                            .bold()
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .padding(.horizontal, 30)
                            .padding(.top, -10)
                    }
                    Divider()
                }
                Section(header: Text("Selling info").bold().padding(.horizontal)) {
                    TextField("VAT Number", text: $vatNumber, prompt: Text(user.vatNumber ?? "VAT Number").foregroundColor(.gray))
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                }
                TextField("National Insurance Number", text: $nationalInsuranceNumber, prompt: Text(user.nationalInsuranceNumber ?? "National Insurance Number").foregroundColor(.gray))
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 2)
                    }
                    .padding(.horizontal)
                Divider()
                if !isSocialProviderAccount {
                    HStack {
                        Spacer()
                        Text("Changing the password will sign you out")
                            .foregroundStyle(.gray)
                            .bold()
                            .padding(.leading)
                            .font(.title3)
                        Spacer()
                    }
                }
                Spacer()
                
                Button(action: {
                    var newUser = User(id: user.id!, firstName: firstName, lastName: lastName, username: user.username, password: password, bio: bio, website: webSite, social: social, geographicArea: geographicArea, google: user.google, facebook: user.facebook, apple: user.apple, profilePicture: user.profilePicture, iban: iban, vatNumber: vatNumber, nationalInsuranceNumber: nationalInsuranceNumber)
                    
                    if isPasswordEmpty {
                        newUser.password = user.password
                    }
                    
                    if isPasswordValid {
                        newUser.password = password
                        changed = true
                    }
                    
                    if isSocialProviderAccount {
                        newUser.password = ""
                    }
                    
                    if iban.isEmpty {
                        newUser.iban = nil
                    }
                    
                    if isIbanValid {
                        newUser.iban = iban
                    }
                    
                    if bio.isEmpty {
                        newUser.bio = nil
                    }
                    
                    if webSite.isEmpty {
                        newUser.website = nil
                    }
                    
                    if social.isEmpty {
                        newUser.social = nil
                    }
                    
                    if geographicArea.isEmpty {
                        newUser.geographicArea = nil
                    }
                    
                    if vatNumber.isEmpty {
                        newUser.vatNumber = nil
                    }
                    
                    if nationalInsuranceNumber.isEmpty {
                        newUser.nationalInsuranceNumber = nil
                    }
                   
                    Task {
                        do {
                            try await userViewModel.updateUser(user: newUser)
                                showConfirmation = true
                                showAlert = true
                        } catch {
                            print(error)
                            showError = true
                            showAlert = true
                        }
                    }
                    
                }) {
                    Text("Save Changes")
                        .bold()
                        .frame(width: 360, height: 45)
                        .background(Color.blue.gradient)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .alert(isPresented: $showAlert) {
                if showError {
                    Alert(title: Text("Error"), message: Text("Error saving changes."), dismissButton: .default(Text("Ok"), action: {
                        showError = false
                        showAlert = false
                    }))
                } else  {
                    Alert(title: Text("Success"), message: Text("Changes successfully saved!"), dismissButton: .default(Text("Ok"), action: {
                        showConfirmation = false
                        showAlert = false
                        dismiss()
                    }))
                }
            }
            .navigationBarTitle("Edit Profile")
        }
    }
    
}

#Preview {
    ModifyProfileView(user: User(id: 1, firstName: "John", lastName: "Doe", username: "johndoe", password: "password", bio: "Developer", website: "example.com", social: "social", geographicArea: "USA", google: nil, facebook: nil, apple: nil, profilePicture: "profile_picture", iban: "ibann", vatNumber: "vat_number", nationalInsuranceNumber: "national_insurance_number"), userViewModel: UserViewModel(), changed: .constant(false))
    }

