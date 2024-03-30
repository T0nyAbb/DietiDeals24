//
//  LoginView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 12/01/24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit



struct LoginView: View {
    @StateObject var loginVm: LoginViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var vm = GoogleSignInButtonViewModel()
    @State var log = LoginViewModel.shared.logged
    @State var appleLogged: Bool = LoginViewModel.shared.appleIsLogged
    @State var email: String = ""
    @State var password: String = ""
    @State var user: User?
    @State var token: Token?
    @State var animateButton = false
    @State var showPassword = false
    @State var showError = false
    @Environment(\.colorScheme) var colorScheme
    
    
    
    
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack {
                        //                    Image(systemName: "person.circle")
                        //                        .resizable()
                        //                        .aspectRatio(contentMode: .fit)
                        //                        .frame(width: 75, height: 75)
                        //                        .padding(.bottom, 30)
                        
                        TextField("Email",
                                  text: $email ,
                                  prompt: Text("Email").foregroundColor(.gray)
                        )
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        }
                        
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
                                    .foregroundColor(.blue) // how to change image based in a State variable
                            }
                            
                        }
                        .padding(.vertical)
                        
                        Button {
                            Task {
                                do {
                                    token = try await loginVm.login(username: email, password: password)
                                } catch {
                                    print(error.localizedDescription)
                                    self.showError = true
                                }
                            }
                            
                            
                        } label: {
                            Text("Login")
                                .frame(width: 360, height: 45)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            
                        }
                        Divider()
                            .padding()
                        HStack {
                            SignInWithAppleButton(.signIn) { request in
                                request.requestedScopes = [.fullName, .email]
                            } onCompletion: { result in
                                switch result {
                                case .success(let authResults):
                                    print("Authorisation successful")
                                    if let appleEmail = UserDefaults.standard.string(forKey: "AppleEmail") {
                                        self.appleLogged = true
                                    }
                                    switch authResults.credential {
                                    case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                                        if appleIdCredentials.email != nil {
                                            UserDefaults.standard.setValue(appleIdCredentials.email, forKey: "AppleEmail")
                                            UserDefaults.standard.setValue(appleIdCredentials.fullName?.givenName, forKey: "AppleName")
                                            UserDefaults.standard.setValue(appleIdCredentials.fullName?.familyName, forKey: "AppleSurname")
                                            UserDefaults.standard.setValue(appleIdCredentials.user, forKey: "AppleUser")
                                        }
                                        let firstName: String = (appleIdCredentials.fullName?.givenName)!
                                        let lastName: String = (appleIdCredentials.fullName?.familyName)!
                                        let username: String = appleIdCredentials.email!
                                        print(appleIdCredentials.email)
                                        print(appleIdCredentials.fullName?.givenName)
                                        print(appleIdCredentials.fullName?.familyName)
                                        Task {
                                            do {
                                                token = try await loginVm.signUp(user: .init(id: nil, firstName: firstName, lastName: lastName, username: username, password: nil, bio: nil, website: nil, social: nil, geographicArea: nil, google: nil, facebook: nil, apple: username, profilePicture: nil, iban: nil, vatNumber: nil, nationalInsuranceNumber: nil))
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        }
                                        print(appleIdCredentials.user)
                                        loginVm.checkAppleLogin()
                                        self.appleLogged = true
                                    default:
                                        print(authResults)
                                    }
                                    
                                case .failure(let error):
                                    print("Authorisation failed: \(error.localizedDescription)")
                                }
                            }
                            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                            .frame(width: 360, height: 45)
                        }
                        GoogleSignInButton(viewModel: vm, action: authViewModel.signIn)
                            .accessibilityIdentifier("GoogleSignInButton")
                            .accessibility(hint: Text("Sign in with Google button."))
                            .frame(height: 55)
                        FBLog(loginVm: self.loginVm)
                            .frame(height: 45)
                    }
                    .padding()
                    VStack {
                        Spacer()
                        Text("Don't have an account?")
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .padding(.top, 120)
                        NavigationLink {
                            SignupView()
                        } label: {
                            Text("Sign Up")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)

                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity) // how to make a button fill all the space available horizontaly
                        .background(
                            LinearGradient(colors: [.blue, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .hueRotation(.degrees(animateButton ? 45 : 0))
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                        animateButton.toggle()
                                    }
                                }
                        )
                        .cornerRadius(10)
                        .padding()
                    }
                    .navigationTitle("Login")
                    .alert(isPresented: $showError, content: {
                        Alert(title: Text("Invalid credentials!"), dismissButton: .default(Text("Ok"), action: {
                            showError = false
                        }))
                    })
                    ZStack {
                        if(GIDSignIn.sharedInstance.currentUser != nil){
                            Text("")
                                .onAppear {
                                    loginVm.checkStatus()
                                    self.log = true
                                }
                        } else if AccessToken.isCurrentAccessTokenActive {
                            Text("")
                                .onAppear {
                                    loginVm.setFbIsLogged(isLogged: true)
                                    self.log = true
                                }
                        }
                        else if appleLogged {
                            Text("")
                                .onAppear {
                                    self.log = true
                                }
                            
                        }
                        else if loginVm.checkLogin() {
                            Text("")
                                .onAppear {
                                    self.log = true
                                }
                        }
                        
                        
                    }
                    Spacer()
                    
                }
                .navigationDestination(isPresented: $log) {
                    MainView(loginVm: loginVm)
                        .environmentObject(authViewModel)
                        .onDisappear {
                            self.appleLogged = loginVm.appleIsLogged
                            self.email = ""
                            self.password = ""
                        }
                }
            }
        }
    }
}





#Preview {
    LoginView(loginVm: LoginViewModel.shared)
        .environmentObject(AuthenticationViewModel())
}
