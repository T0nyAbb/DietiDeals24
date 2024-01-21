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
    
    
    

  var body: some View {
      NavigationStack {
          VStack {
              Spacer()
              VStack {
                  HStack {
                      SignInWithAppleButton(.continue) { request in
                          request.requestedScopes = [.fullName, .email]
                      } onCompletion: { result in
                          switch result {
                          case .success(let authResults):
                              print("Authorisation successful")
                              print(authResults)
                              
                          case .failure(let error):
                              print("Authorisation failed: \(error.localizedDescription)")
                          }
                      }
                      // black button
                      .signInWithAppleButtonStyle(.whiteOutline)
                      .frame(width: 360, height: 50)
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
                  
                  else {
                      Text("")
                  }
                  
                  
              }
              Spacer()
              
          }
          .navigationDestination(isPresented: $log) {
              HomeView(userVm: userVm)
                  .environmentObject(authViewModel)
          }
      }
  }
}





#Preview {
    SignUpView(userVm: UserViewModel.shared)
}
