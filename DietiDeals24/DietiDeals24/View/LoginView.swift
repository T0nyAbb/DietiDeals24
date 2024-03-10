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
    @ObservedObject var loginVm: LoginViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var vm = GoogleSignInButtonViewModel()
    @State var log = LoginViewModel.shared.logged
    @State var appleLogged: Bool = LoginViewModel.shared.appleIsLogged
    @State var email: String = ""
    @State var password: String = ""
    @State var user: User?
    @State var token: Token?
    @State var animateButton = false
    @Environment(\.colorScheme) var colorScheme
    
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 30)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    
                    Button {
                        Task {
                            do {
                                token = try await loginVm.login(username: email, password: password)
                            } catch {
                                print(error.localizedDescription)
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
                                    print(appleIdCredentials.email)
                                    print(appleIdCredentials.fullName?.givenName)
                                    print(appleIdCredentials.fullName?.familyName)
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
                                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                                        animateButton.toggle()
                                    }
                                }
                    )
                    .cornerRadius(20)
                    .padding()
                }
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
                    else if token != nil {
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





#Preview {
    LoginView(loginVm: LoginViewModel.shared)
        .environmentObject(AuthenticationViewModel())
}
