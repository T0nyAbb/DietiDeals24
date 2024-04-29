//
//  DietiDeals24App.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 12/01/24.
//

import Foundation
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin
import SwiftUI
import FBSDKCoreKit
import UserNotifications

@main
struct DietiDeals24App: App {
    @StateObject var authViewModel: AuthenticationViewModel = AuthenticationViewModel()
    @StateObject var loginVm: LoginViewModel = LoginViewModel.shared
    
    init() {
        configureAmplify()
        requestNotificationsPermission()
    }
    
    var body: some Scene {
        WindowGroup {
                LoginView(loginVm: loginVm)
                    .onAppear {
                        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
                    }
            .environmentObject(authViewModel)
            .onOpenURL(perform: { url in
                ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: UIApplication.OpenURLOptionsKey.annotation)
            })
            
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("Amplify configured successfully!")
        } catch {
            print("Failed to configure Amplify", error)
        }
    }
    private func requestNotificationsPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications permission granted!")
            } else if let error {
                print(error)
            }
        }
    }
}
