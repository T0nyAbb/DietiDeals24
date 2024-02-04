//
//  MainView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 21/01/24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit

struct MainView: View {
    @ObservedObject var userVm: UserViewModel
    
    @State private var selection = 1

    var body: some View {
        

        TabView(selection:$selection) {
             AuctionsView()
                  .tabItem {
                      Image(systemName: "tag.fill")
                      Text("Auctions")
                  }
                  .tag(1)
             NotificationsView()
                  .tabItem {
                      Image(systemName: "bell.fill")
                      Text("Notifications")
                  }
                  .tag(2)
             MyAuctionsView()
                  .tabItem {
                      Image(systemName: "bookmark.fill")
                      Text("My Auctions")
                  }
                  .tag(3)
            ProfileView(userVm: userVm)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainView(userVm: UserViewModel.shared)
}
