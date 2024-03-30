//
//  NotificationListRow.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 30/03/24.
//

import SwiftUI

struct NotificationListRow: View {
    
    @State var notification: Notification
    
    var body: some View {
        HStack {
            if notification.body.contains("WON") {
                Image(systemName: "checkmark.seal.fill")
                    .font(.title)
            } else if notification.body.contains("lost") {
                Image(systemName: "xmark.app")
                    .font(.title)
            } else {
                Image(systemName: "info.square")
                    .font(.title)
            }
            Text(notification.body)
                .padding(.horizontal)
                .font(.system(size: 18))
                .bold()
        }
    }
}

#Preview {
    NotificationListRow(notification: .init(notificationId: 0, auctionId: 0, receiverId: 0, body: "YOU WON! - You just won the Auction-title auction!"))
}
