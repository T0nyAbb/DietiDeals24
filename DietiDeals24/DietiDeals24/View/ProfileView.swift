//
//  ProfileView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 22/01/24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit

struct ProfileView: View {
    @StateObject var loginVm: LoginViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var vm = GoogleSignInButtonViewModel()
    @State var fbLogged: Bool = AccessToken.isCurrentAccessTokenActive
    @State var googleLogged: Bool = GIDSignIn.sharedInstance.currentUser != nil
    @Environment(\.dismiss) var dismiss
    @State var loggedOut: Bool = false
    @State var appleLogged: Bool = LoginViewModel.shared.appleIsLogged
    
    
    var body: some View {
            NavigationView {
                VStack {
                    if fbLogged {
                        loginVm.getfbImage()
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        Text(loginVm.getfbUserName())
                        Text(loginVm.fbEmail)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        FBLog(loginVm: loginVm)
                            .frame(height: 45)
                        if !AccessToken.isCurrentAccessTokenActive {
                            let _ = print("logged out from fb")
                            let _ = loggedOut = true
                            let _ = dismiss()
                        }
                    }
                    else if googleLogged {
                        
                        loginVm.userDetails()
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        loginVm.userName()
                        loginVm.getEmail()
                            .padding()
                        Button(action: {
                            authViewModel.signOut()
                            loggedOut = true
                            dismiss()
                        }) {
                            Text("Sign Out")
                        }
                    }
                    
                    else if appleLogged {
                        loginVm.getAppleName()
                        loginVm.getAppleEmail()
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .padding()
                        Button(action: {
                            loginVm.appleSignOut()
                            loggedOut = true
                            dismiss()
                        }) {
                            Text("Sign Out")
                        }
                    }
                }
                .navigationTitle("Profile")
            }

            
        }
    
        
}

#Preview {
    ProfileView(loginVm: LoginViewModel.shared)
}
