//
//  NotificationsView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 22/01/24.
//

import SwiftUI

struct NotificationsView: View {
    
    var notificationViewModel: NotificationViewModel
    
    @StateObject var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            if !notificationViewModel.currentUserNotifications.isEmpty {
                List {
                ForEach(notificationViewModel.currentUserNotifications) { notification in
                    NotificationListRow(notification: notification)
                }.onDelete(perform: delete)
            }
                .refreshable {
                    do {
                        try await notificationViewModel.updateCurrentUserNotifications(user: loginViewModel.user!)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                .navigationTitle("Notifications")

            } else {
                ScrollView(.vertical, showsIndicators: false) {
                ContentUnavailableView {
                    Label("No New Notifications", systemImage: "bell")
                        .padding(.top, 160)
                }
                .refreshable {
                    do {
                        try await notificationViewModel.updateCurrentUserNotifications(user: loginViewModel.user!)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
                .navigationTitle("Notifications")
                .onAppear {
                    Task {
                        do {
                            try await notificationViewModel.updateCurrentUserNotifications(user: loginViewModel.user!)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }

                
        }
            
        
    }
    
    func delete(at offsets: IndexSet) {
        for i in offsets {
            Task {
                print(i)
                try await notificationViewModel.deleteNotification(notification: notificationViewModel.currentUserNotifications[i])
                notificationViewModel.currentUserNotifications.remove(atOffsets: offsets)
            }
        }
    }
}

#Preview {
    NotificationsView(notificationViewModel: NotificationViewModel(), loginViewModel: LoginViewModel.shared)
}
