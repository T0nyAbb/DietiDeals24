//
//  DietiDeals24App.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 12/01/24.
//

import Foundation
import SwiftUI
import FBSDKCoreKit

@main
struct DietiDeals24App: App {
    @StateObject var authViewModel: AuthenticationViewModel = AuthenticationViewModel()
    @StateObject var userVm: UserViewModel = UserViewModel.shared
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SignUpView(userVm: userVm)
                    .onAppear {
                        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
                    }
            }
            .environmentObject(authViewModel)
            .onOpenURL(perform: { url in
                ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: UIApplication.OpenURLOptionsKey.annotation)
            })
            
        }
    }
}