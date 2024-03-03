//
//  UserViewModel.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 04/02/24.
//

import Foundation


@Observable class UserViewModel {
    
    func getUser() async throws -> User {
        let endpoint = "http://localhost:8080/api/users/3"
        
        guard let url = URL(string: endpoint) else { throw UserError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw UserError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(User.self, from: data)
        } catch {
            throw UserError.invalidData
        }
    }
    

    // Define a struct to represent your login request body


    // Define a struct to represent your user model
//    struct User: Codable {
//        let userId: String
//        // Add other user-related properties as needed
//    }

    

    // Example usage
//    async {
//        do {
//            let user = try await loginAsync(username: "your_username", password: "your_password")
//            print("Login successful. User ID: \(user.userId)")
//        } catch {
//            // Handle login errors
//            print("Login failed with error: \(error)")
//        }
//    }


    
}
