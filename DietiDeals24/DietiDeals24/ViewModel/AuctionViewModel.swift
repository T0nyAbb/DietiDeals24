//
//  AuctionViewModel.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 26/03/24.
//

import Foundation

@Observable
class AuctionViewModel {
    
    
    var fixedTimeAuctions: [FixedTimeAuction] = [FixedTimeAuction]()
    
    var currentUserFixedTimeAuctions: [FixedTimeAuction] = [FixedTimeAuction]()
    
    
    func createFixedTimeAuction(auction: FixedTimeAuction) async throws -> FixedTimeAuction {
        // Construct the URL for your signup endpoint
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .FIXED_TIME_AUCTION)) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called create fixed time auction")

        // Create the signup request body

        // Serialize the request body to JSON
        let encoder = JSONEncoder()
        
        encoder.dateEncodingStrategy = .iso8601
        
        
        guard let jsonData = try? encoder.encode(auction) else {
            print("encoding error")
            throw NSError(domain: "JSON Encoding Error", code: 0, userInfo: nil)
        }
        
        print(String(data: jsonData, encoding: .utf8)!)
        
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
            // Perform the signup request asynchronously
            let (data, response) = try await URLSession.shared.data(for: request)

            // Handle the response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Decode the auction information from the response data
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let auction = try decoder.decode(FixedTimeAuction.self, from: data)
                return auction
            } else {
                // Handle unsuccessful upload (non-200 status code)
                print("auction publication failed")
                throw NSError(domain: "Auction Upload Failed", code: 0, userInfo: nil)
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error.localizedDescription)
            throw error
        }
    }
     
    func getAllFixedTimeAuction() async throws {
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .FIXED_TIME_AUCTION) + "s") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called getAllFixedTimeAuction")
        
        var user = try await UserViewModel().getUserByEmail(username: UserDefaults.standard.string(forKey: "Username")!)


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
                decoder.dateDecodingStrategy = .iso8601

                self.fixedTimeAuctions = try decoder.decode([FixedTimeAuction].self, from: data)
                
                self.currentUserFixedTimeAuctions = self.fixedTimeAuctions.filter { $0.sellerId == user.id}
                
                self.fixedTimeAuctions = self.fixedTimeAuctions.filter { $0.sellerId != user.id}
                
                
                print("auctions successfully retrieved!")
            } else {
            
                throw NSError(domain: "Login Failed", code: 0, userInfo: nil)
                
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error.localizedDescription)
            throw error
            
        }
    }
    
    
}
