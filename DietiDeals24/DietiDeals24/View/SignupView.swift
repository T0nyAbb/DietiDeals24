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
    @State private var showPassword: Bool = false
    @State var user: User?
    @State var token: Token?
    @State var animateButton = false
    @Environment(\.dismiss) var dismiss
    
    private var isSignInButtonDisabled: Bool {
        [firstName, lastName, username, password, confirmPassword].contains(where: \.isEmpty) && password == confirmPassword

    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Spacer()
                TextField("First Name",
                          text: $firstName ,
                          prompt: Text("First Name").foregroundColor(.gray)
                          
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
                          prompt: Text("Last Name").foregroundColor(.gray)
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
                          prompt: Text("Email").foregroundColor(.gray)
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
                                      prompt: Text("Password").foregroundColor(.gray)) // How to change the color of the TextField Placeholder
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        } else {
                            SecureField("Password", // how to create a secure text field
                                        text: $password,
                                        prompt: Text("Password").foregroundColor(.gray)) // How to change the color of the TextField Placeholder
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
                            .foregroundColor(showPassword ? .blue : .gray) // how to change image based in a State variable
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
                                .stroke(.gray, lineWidth: 2)
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
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                    }
                
                Spacer()
                
                Button {
                    Task {
                        do {
                            token = try await loginVm.signUp(user: .init(firstName: self.firstName, lastName: self.lastName, username: self.username, password: self.password, bio: nil, website: nil, social: nil, google: nil, facebook: nil, apple: nil, profilePicture: nil, iban: nil, vatNumber: nil, nationalInsuranceNumber: nil))
                            if let tkn = token {
                                dismiss()
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
                        .hueRotation(.degrees(animateButton ? 45 : 0))

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
            
        }
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    SignupView()
}
