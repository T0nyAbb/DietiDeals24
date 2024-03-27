//
//  NotificationsView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 22/01/24.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        NavigationView {
            VStack {
                ContentUnavailableView {
                    Label("No New Notifications", systemImage: "bell")
                }
            }
                .navigationTitle("Notifications")
        }
            
        
    }
}

#Preview {
    NotificationsView()
}
