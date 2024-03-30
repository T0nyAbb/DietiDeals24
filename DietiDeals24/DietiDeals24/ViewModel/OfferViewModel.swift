//
//  OfferViewModel.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 29/03/24.
//

import Foundation

@Observable
class OfferViewModel {
    
    func createOffer(offer: Offer) async throws -> Offer {
        // Construct the URL for your signup endpoint
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .OFFER)) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called create offer")
        
      // Serialize the request body to JSON
        let encoder = JSONEncoder()
        
        
        
        guard let jsonData = try? encoder.encode(offer) else {
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
            // Perform the request asynchronously
            let (data, response) = try await URLSession.shared.data(for: request)

            // Handle the response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Decode the offer information from the response data
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let offer = try decoder.decode(Offer.self, from: data)
                return offer
            } else {
                // Handle unsuccessful upload (non-200 status code)
                print("offer publication failed")
                throw NSError(domain: "Auction Upload Failed", code: 0, userInfo: nil)
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error)
            throw error
        }
    }
    
}
