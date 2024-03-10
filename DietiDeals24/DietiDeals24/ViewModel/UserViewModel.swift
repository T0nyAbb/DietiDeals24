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
    
    func getUserByEmail(username: String) async throws -> User {
        // Construct the URL for your login endpoint
        guard let url = URL(string: "http://localhost:8080/api/user/\(username)") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called login func with username: \(username)")

        // Create the login request body
        let requestBody = username

        // Serialize the request body to JSON
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            print("encoding error")
            throw NSError(domain: "JSON Encoding Error", code: 0, userInfo: nil)
        }

        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = UserDefaults.standard.string(forKey: "SignUpToken") else {
            print("Token not found")
            throw UserError.tokenNotFound
        }
        let auth = "Bearer ".appending(token)
        request.setValue(auth, forHTTPHeaderField: "Authorization")
        print(auth)
        do {
            // Perform the login request asynchronously
            let (data, response) = try await URLSession.shared.data(for: request)

            // Handle the response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the user information from the response data
                let user = try JSONDecoder().decode(User.self, from: data)
                print("user retrieved!")
                return user
            } else {
                // Handle unsuccessful login (non-200 status code)
                print("unsuccesful login")
                throw NSError(domain: "Login Failed", code: 0, userInfo: nil)
                
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            throw error
            
        }
    }


    
}
