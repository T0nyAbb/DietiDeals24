//
//  UserViewModel.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 04/02/24.
//

import Foundation


@Observable 
class UserViewModel {
    
    func getUserByEmail(username: String) async throws -> User {
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .USER) + username) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called getUserByEmail func with username: \(username)")

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
                // Decode the user information from the response data
                let user = try JSONDecoder().decode(User.self, from: data)
                print("user successfully retrieved!")
                return user
            } else {
                // Handle unsuccessful login (non-200 status code)
                print("unsuccesful login")
                throw NSError(domain: "Login Failed", code: 0, userInfo: nil)
                
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error.localizedDescription)
            throw error
            
        }
    }
    
    func updateUser(user: User) async throws -> User {
        guard let id = user.id else { throw NSError(domain: "Invalid User Id", code: 0)}
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .USER) + id.description) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called updateUser func with username: \(user.username)")

        let requestBody = user

        // Serialize the request body to JSON
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            print("encoding error")
            throw NSError(domain: "JSON Encoding Error", code: 0, userInfo: nil)
        }

        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = jsonData
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
                // Decode the user information from the response data
                let user = try JSONDecoder().decode(User.self, from: data)
                print("user successfully updated!")
                return user
            } else {
                // Handle unsuccessful login (non-200 status code)
                print("unsuccesful update")
                throw NSError(domain: "Update Failed", code: 0, userInfo: nil)
                
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            throw error
            
        }
    }
    
    func deleteUser(user: User) async throws {
        guard let id = user.id else { throw NSError(domain: "Invalid User Id", code: 0)}
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .USER) + id.description) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called updateUser func with username: \(user.username)")

        let requestBody = user

        // Serialize the request body to JSON
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            print("encoding error")
            throw NSError(domain: "JSON Encoding Error", code: 0, userInfo: nil)
        }

        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = jsonData
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
                // Decode the user information from the response data
                let user = try JSONDecoder().decode(User.self, from: data)
                print("user successfully deleted!")
            } else {
                // Handle unsuccessful login (non-200 status code)
                print("unsuccesful update")
                throw NSError(domain: "Update Failed", code: 0, userInfo: nil)
                
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            throw error
        }
        
    }
    
    
    
    


    
}
