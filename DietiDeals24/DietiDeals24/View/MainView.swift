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
    
    
    private var notificationsCount: Int {
        return notificationViewModel.currentUserNotifications.count
    }

    var body: some View {
        TabView(selection:$selection) {
            AuctionsView(selectedAuction: $auctionSelection, auctionViewModel: auctionsViewModel, userViewModel: userViewModel, notificationViewModel: notificationViewModel)
                .id(UUID())
                  .tabItem {
                      Image(systemName: "tag.fill")
                      Text("Auctions")
                  }
                  .tag(1)
            NotificationsView(notificationViewModel: notificationViewModel, loginViewModel: LoginViewModel.shared)
                .id(UUID())
                  .tabItem {
                      Image(systemName: "bell.fill")
                      Text("Notifications")

                  }
                  .badge(notificationsCount)
                  .tag(2)
                  
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
        .task {
                let task = Task {
                    print(UserDefaults.standard.string(forKey: "Token"))
                        await loginVm.updateCurrentUser()
                }
                Task {
                    _ = await task.value
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                        Task {
                            if loginVm.user == nil && !loginVm.checkLogin() {
                                print("Dismissing, \(loginVm.user), checklog: \(loginVm.checkLogin())")
                                dismiss()
                            } else {
                                try await notificationViewModel.updateCurrentUserNotifications(user: loginVm.user!)
                                try await userViewModel.getAllUsers()
                            }
                        }
                    }

            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainView(loginVm: LoginViewModel.shared)
}
