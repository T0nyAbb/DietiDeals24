//
//  NotificationViewModel.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 29/03/24.
//

import Foundation

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

                self.currentUserNotifications = try decoder.decode([Notification].self, from: data)
                
                self.currentUserNotifications = self.currentUserNotifications.sorted { $0.notificationId > $1.notificationId }
                
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
    
}
