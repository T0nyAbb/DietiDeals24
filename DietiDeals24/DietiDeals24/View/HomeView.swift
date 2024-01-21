//
//  HomeView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 21/01/24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit

struct HomeView: View {
    @ObservedObject var userVm: UserViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var vm = GoogleSignInButtonViewModel()
    @State var fbLogged: Bool = UserViewModel.shared.fbIsLogged
    @State var googleLogged: Bool = GIDSignIn.sharedInstance.currentUser != nil
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if fbLogged {
                    userVm.getfbImage()
                    Text(userVm.fbEmail)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    FBLog(userVm: userVm)
                        .frame(height: 45)
                    let _ = print(AccessToken.isCurrentAccessTokenActive)
                    if !AccessToken.isCurrentAccessTokenActive {
                        let _ = print("logged out from fb")
                        let _ = dismiss()
                    }
                        
                    
                }
                else if googleLogged {
                    userVm.userDetails()
                    userVm.userName()
                    userVm.getEmail()
                        .padding()
                    Button(action: {
                        authViewModel.signOut()
                        dismiss()
                    }) {
                        Text("Sign Out")
                    }
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .onAppear {

        }
        
    }
        
}

#Preview {
    HomeView(userVm: UserViewModel.shared)
}
