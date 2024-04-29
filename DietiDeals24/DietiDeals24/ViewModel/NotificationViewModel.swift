//
//  NotificationViewModel.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 29/03/24.
//

import Foundation
import UserNotifications

@Observable
class NotificationViewModel {
    
    var currentUserNotifications: [Notification] = [Notification]()
    
    func updateCurrentUserNotifications(user: User) async throws {
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .NOTIFICATION) + user.id!.description) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called get notifications")
        

        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = UserDefaults.standard.string(forKey: "Token") else {
            print("Token not found")
            throw UserError.tokenNotFound
        }
        let auth = "Bearer ".appending(token)
        request.setValue(auth, forHTTPHeaderField: "Authorization")
        do {
            // Perform the login request asynchronously
            let (data, response) = try await URLSession.shared.data(for: request)

            // Handle the response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()

                var temp = try decoder.decode([Notification].self, from: data)
                temp.reverse()
                if self.currentUserNotifications != temp {
                    self.currentUserNotifications = temp
                }                
                print("notifications successfully retrieved!")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
                print("No notifications for the selected user")
            } else {
                throw NSError(domain: "Notification retrieval failed", code: 0, userInfo: nil)
                
            }
        } catch {
            // Handle any errors that occurred during the request
            print("notification generic error")
            print(error)
            throw error
            
        }
    }
    
    func deleteNotification(notification: Notification) async throws {
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .NOTIFICATION) + notification.notificationId.description) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called delete notification")
        

        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = UserDefaults.standard.string(forKey: "Token") else {
            print("Token not found")
            throw UserError.tokenNotFound
        }
        let auth = "Bearer ".appending(token)
        request.setValue(auth, forHTTPHeaderField: "Authorization")
        do {
            // Perform the request asynchronously
            let (data, response) = try await URLSession.shared.data(for: request)

            // Handle the response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("notifications successfully deleted!")
                UserDefaults.standard.setValue(self.currentUserNotifications.count-1, forKey: "Notifications")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
                print("No notification found for selected id: \(notification.notificationId)")
            } else {
                throw NSError(domain: "Notification retrieval failed", code: 0, userInfo: nil)
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error.localizedDescription)
            throw error
            
        }
    }
    
    func sendNotification(body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "DietiDeals24"
        content.subtitle = body
        content.sound = UNNotificationSound.default
        
        print("sending notification")
        // show this notification

        let nextTriggerDate = Calendar.current.date(byAdding: .second, value: 1, to: date)!
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: nextTriggerDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleNotification(_ auction: Auction) {
        if let inverseAuction = auction as? InverseAuction {
            sendNotification(body: "Your auction \(inverseAuction.title) just ended, check the result in the app!", date: inverseAuction.expiryDate)
        } else if let fixedTimeAuction = auction as? FixedTimeAuction {
            sendNotification(body: "Your auction \(fixedTimeAuction.title) just ended, check the result in the app!", date: fixedTimeAuction.expiryDate)
        }
        
        
    }
    
}
