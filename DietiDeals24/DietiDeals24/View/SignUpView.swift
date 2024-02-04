//
//  SignUpView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 12/01/24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit



struct SignUpView: View {
    @ObservedObject var userVm: UserViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var vm = GoogleSignInButtonViewModel()
    @State var manager = LoginManager()
    @State var log = UserViewModel.shared.logged
    @State var appleLogged: Bool = UserViewModel.shared.appleIsLogged
    @Environment(\.colorScheme) var colorScheme
    
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack {
                    HStack {
                        SignInWithAppleButton(.signIn) { request in
                            request.requestedScopes = [.fullName, .email]
                        } onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                print("Authorisation successful")
                                if let email = UserDefaults.standard.string(forKey: "AppleEmail") {
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
                                    userVm.checkAppleLogin()
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
                    FBLog(userVm: self.userVm)
                        .frame(height: 45)
                    VStack {
                        
                        
                    }
                    
                }
                .padding()
                VStack {
                    if(GIDSignIn.sharedInstance.currentUser != nil){
                        Text("")
                            .padding()
                            .onAppear {
                                userVm.checkStatus()
                                self.log = true
                            }
                    } else if AccessToken.isCurrentAccessTokenActive {
                        Text("")
                            .padding()
                            .onAppear {
                                userVm.setFbIsLogged(isLogged: true)
                                self.log = true
                            }
                    }
                    else if appleLogged {
                        Text("")
                            .padding()
                            .onAppear {
                                self.log = true
                            }
                        
                    }
                    else {
                        Text("")
                    }
                    
                    
                }
                Spacer()
                
            }
            .navigationDestination(isPresented: $log) {
                MainView(userVm: userVm)
                    .environmentObject(authViewModel)
                    .onDisappear {
                        self.appleLogged = userVm.appleIsLogged
                    }
            }
        }
    }
}





#Preview {
    SignUpView(userVm: UserViewModel.shared)
}
