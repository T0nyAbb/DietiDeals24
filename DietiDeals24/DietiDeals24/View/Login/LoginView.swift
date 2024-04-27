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
                ZStack {
                    Spacer().containerRelativeFrame([.horizontal, .vertical])
                    VStack {
                        VStack {
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
                                        .foregroundColor(.blue)
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
                                    .frame(width: UIScreen.main.bounds.width*0.95,height: 45)
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
                                        if UserDefaults.standard.string(forKey: "AppleEmail") != nil {
                                            self.appleLogged = true
                                        }
                                        switch authResults.credential {
                                        case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                                            if appleIdCredentials.email != nil {
                                                print(appleIdCredentials.email as Any)
                                                UserDefaults.standard.setValue(appleIdCredentials.email, forKey: "AppleEmail")
                                                UserDefaults.standard.setValue(appleIdCredentials.email, forKey: "Username")
                                            }
                                            let username: String = UserDefaults.standard.string(forKey: "AppleEmail")!
                                            if appleIdCredentials.fullName != nil {
                                                print(appleIdCredentials.fullName as Any)
                                                UserDefaults.standard.setValue(appleIdCredentials.fullName?.givenName, forKey: "AppleName")
                                                UserDefaults.standard.setValue(appleIdCredentials.fullName?.familyName, forKey: "AppleSurname")
                                            }
                                            let firstName: String? = UserDefaults.standard.string(forKey: "AppleName")
                                            let lastName: String? = UserDefaults.standard.string(forKey: "AppleSurname")
                                            UserDefaults.standard.setValue(appleIdCredentials.user, forKey: "AppleUser")
                                            
                                            print(appleIdCredentials.email as Any)
                                            print(appleIdCredentials.fullName?.givenName as Any)
                                            print(appleIdCredentials.fullName?.familyName as Any)
                                            Task {
                                                do {
                                                    token = try await loginVm.signUpWithSocialProvider(user: .init(id: nil, firstName: firstName, lastName: lastName, username: username, password: "", bio: nil, website: nil, social: nil, geographicArea: nil, google: nil, facebook: nil, apple: username, profilePicture: nil, iban: nil, vatNumber: nil, nationalInsuranceNumber: nil))
                                                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                                                        self.appleLogged = true
                                                    }
                                                    if token != nil {
                                                        print("token not null")
                                                        loginVm.checkAppleLogin()
                                                    }
                                                    print("appl logged: \(appleLogged), token: \(token)")
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                            print(appleIdCredentials.user)
                                        default:
                                            print(authResults)
                                        }
                                        
                                    case .failure(let error):
                                        print("Authorisation failed: \(error)")
                                    }
                                }
                                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                                .frame(height: 45)
                            }
                            GoogleSignInButton(viewModel: vm, action: authViewModel.signIn)
                                .accessibilityIdentifier("GoogleSignInButton")
                                .accessibility(hint: Text("Sign in with Google button."))
                                .frame(height: 55)
                            FBLog(loginVm: self.loginVm)
                                .frame(height: 45)
                            VStack {
                                Spacer()
                                Text("Don't have an account?")
                                    .font(.callout)
                                    .foregroundStyle(.gray)
                                    .padding(.top)
                                NavigationLink {
                                    SignupView()
                                } label: {
                                    Text("Sign Up")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                        .frame(height: 50)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            LinearGradient(colors: [.blue, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                .hueRotation(.degrees(animateButton ? 60 : -30))
                                                .onAppear {
                                                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                                                        animateButton.toggle()
                                                    }
                                                }
                                        )
                                }
                                .cornerRadius(10)
                                .padding(.vertical)
                            }
                        }
                        .padding()
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
                            else if appleLogged && token != nil  {
                                Text("")
                                    .onAppear {
                                        self.log = true
                                    }
                                    .onDisappear {
                                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                                            self.appleLogged = false
                                        }
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
                                self.email = ""
                                self.password = ""
                            }
                    }

                }
            }
            .scrollDismissesKeyboard(.immediately)
            .scrollBounceBehavior(.automatic)
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}





#Preview {
    LoginView(loginVm: LoginViewModel.shared)
        .environmentObject(AuthenticationViewModel())
}
