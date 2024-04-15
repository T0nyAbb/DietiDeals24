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
    @StateObject var loginVm: LoginViewModel
    
    var auctionsViewModel = AuctionViewModel()
    
    var userViewModel = UserViewModel()
    
    var notificationViewModel = NotificationViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selection = 1
    
    @State var auctionSelection = 0
    
    @State var myAuctionSelection = 0
    
    @State var notificationsCount: Int?

    var body: some View {
        TabView(selection:$selection) {
            AuctionsView(selectedAuction: $auctionSelection, auctionViewModel: auctionsViewModel, userViewModel: userViewModel, notificationViewModel: notificationViewModel)
                  .tabItem {
                      Image(systemName: "tag.fill")
                      Text("Auctions")
                  }
                  .tag(1)
            NotificationsView(notificationViewModel: notificationViewModel, loginViewModel: LoginViewModel.shared)
                  .tabItem {
                      Image(systemName: "bell.fill")
                      Text("Notifications")
                  }
                  .tag(2)
                  .badge(notificationViewModel.currentUserNotifications.count)
            MyAuctionsView(userVm: userViewModel, loginVm: LoginViewModel.shared, auctionVm: auctionsViewModel, notificationViewModel: notificationViewModel, selectedAuction: $myAuctionSelection)
                .id(UUID())
                  .tabItem {
                      Image(systemName: "bookmark.fill")
                      Text("My Auctions")
                  }
                  .tag(3)
            ProfileView(loginVm: loginVm)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
        .onAppear {
            Task {
                print(UserDefaults.standard.string(forKey: "Token"))
                try await auctionsViewModel.getAllFixedTimeAuction()
                await loginVm.updateCurrentUser()
                try await notificationViewModel.updateCurrentUserNotifications(user: loginVm.user!)
                try await auctionsViewModel.getAllDescendingPriceAuctions()
                try await auctionsViewModel.getAllEnglishAuctions()
                try await auctionsViewModel.getAllInverseAuctions()
                try await userViewModel.getAllUsers()
                self.notificationsCount = notificationViewModel.currentUserNotifications.count
                if loginVm.user == nil {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainView(loginVm: LoginViewModel.shared)
}
