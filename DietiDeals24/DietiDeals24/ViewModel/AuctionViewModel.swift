//
//  AuctionViewModel.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 26/03/24.
//

import Foundation
import SwiftUI

@Observable
final class AuctionViewModel {
    
    var fixedTimeAuctions: [FixedTimeAuction] = [FixedTimeAuction]()
    
    var descendingPriceAuctions: [DescendingPriceAuction] = [DescendingPriceAuction]()
    
    var englishAuctions: [EnglishAuction] = [EnglishAuction]()
    
    var inverseAuctions: [InverseAuction] = [InverseAuction]()
    
    var currentUserFixedTimeAuctions: [FixedTimeAuction] = [FixedTimeAuction]()
    
    var currentUserDescendingPriceAuctions: [DescendingPriceAuction] = [DescendingPriceAuction]()
    
    var currentUserEnglishAuctions: [EnglishAuction] = [EnglishAuction]()
    
    var currentUserInverseAuctions: [InverseAuction] = [InverseAuction]()
    
    var currentUser: User? = LoginViewModel.shared.user
    
     
    
    func createFixedTimeAuction(auction: FixedTimeAuction) async throws -> FixedTimeAuction {
        // Construct the URL for your signup endpoint
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .FIXED_TIME_AUCTION)) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called create fixed time auction")

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
            // Perform the request asynchronously
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
    
    func updateFixedTimeAuction(auction: FixedTimeAuction) async throws -> FixedTimeAuction {
        // Construct the URL for your signup endpoint
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .FIXED_TIME_AUCTION) + "/" + auction.id!.description) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called update fixed time auction")

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
            // Perform the signup request asynchronously
            let (data, response) = try await URLSession.shared.data(for: request)

            // Handle the response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the auction information from the response data
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let auction = try decoder.decode(FixedTimeAuction.self, from: data)
                return auction
            } else {
                // Handle unsuccessful upload (non-200 status code)
                print("auction update failed")
                throw NSError(domain: "Auction Update Failed", code: 0, userInfo: nil)
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
        
        if currentUser == nil {
            currentUser = try await UserViewModel().getUserByEmail(username: UserDefaults.standard.string(forKey: "Username")!)
        }
        
        let user = currentUser!
        


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

                var temp = try decoder.decode([FixedTimeAuction].self, from: data)
            
                temp.reverse()
                
                var temp2 = temp.filter { $0.sellerId == user.id}
                
                if self.currentUserFixedTimeAuctions != temp2 {
                    self.currentUserFixedTimeAuctions = temp2
                }
                
                temp.removeAll { $0.sellerId == user.id || $0.failed == true || $0.active == false}
                
                if self.fixedTimeAuctions != temp {
                    self.fixedTimeAuctions = temp
                }
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
    
    func createDescendingPriceAuction(auction: DescendingPriceAuction) async throws -> DescendingPriceAuction {
        // Construct the URL for your signup endpoint
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .DESCENDING_PRICE_AUCTION)) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

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
                let auction = try decoder.decode(DescendingPriceAuction.self, from: data)
                return auction
            } else {
                // Handle unsuccessful upload (non-201 status code)
                print("auction publication failed")
                throw NSError(domain: "Auction Upload Failed", code: 0, userInfo: nil)
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error)
            throw error
        }
    }
    
    func updateDescendingPriceAuction(auction: DescendingPriceAuction) async throws -> DescendingPriceAuction {
        // Construct the URL for your signup endpoint
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .DESCENDING_PRICE_AUCTION) + "/" + auction.id!.description) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

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
            // Perform the signup request asynchronously
            let (data, response) = try await URLSession.shared.data(for: request)

            // Handle the response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the auction information from the response data
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let auction = try decoder.decode(DescendingPriceAuction.self, from: data)
                return auction
            } else {
                // Handle unsuccessful upload (non-200 status code)
                print("auction update failed")
                throw NSError(domain: "Auction Update Failed", code: 0, userInfo: nil)
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error)
            throw error
        }
    }
    
    func getAllDescendingPriceAuctions() async throws {
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .DESCENDING_PRICE_AUCTION) + "s") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        if currentUser == nil {
            currentUser = try await UserViewModel().getUserByEmail(username: UserDefaults.standard.string(forKey: "Username")!)
        }
        
        let user = currentUser!


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

                var temp = try decoder.decode([DescendingPriceAuction].self, from: data)
                
                temp.reverse()
                
                var temp2 = temp.filter { $0.sellerId == user.id}
                
                if self.currentUserDescendingPriceAuctions != temp2 {
                    self.currentUserDescendingPriceAuctions = temp2
                }
                
                temp.removeAll { $0.sellerId == user.id || $0.failed == true || $0.active == false}
                
                if self.descendingPriceAuctions != temp {
                    self.descendingPriceAuctions = temp
                }
                
                
                
                print("auctions successfully retrieved!")
            } else {
                throw NSError(domain: "Descending price auctions retrieval failed", code: 0, userInfo: nil)
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error.localizedDescription)
            throw error
            
        }
    }
    
    func createEnglishAuction(auction: EnglishAuction) async throws -> EnglishAuction {
        // Construct the URL for your signup endpoint
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .ENGLISH_AUCTION)) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

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
                let auction = try decoder.decode(EnglishAuction.self, from: data)
                return auction
            } else {
                // Handle unsuccessful upload (non-201 status code)
                print("auction publication failed")
                throw NSError(domain: "Auction Upload Failed", code: 0, userInfo: nil)
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error)
            throw error
        }
    }
    
    func updateEnglishAuction(auction: EnglishAuction) async throws -> EnglishAuction {
        // Construct the URL for your signup endpoint
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .ENGLISH_AUCTION) + "/" + auction.id!.description) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

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
            // Perform the signup request asynchronously
            let (data, response) = try await URLSession.shared.data(for: request)

            // Handle the response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the auction information from the response data
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let auction = try decoder.decode(EnglishAuction.self, from: data)
                return auction
            } else {
                // Handle unsuccessful upload (non-200 status code)
                print("auction update failed")
                throw NSError(domain: "Auction Update Failed", code: 0, userInfo: nil)
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getAllEnglishAuctions() async throws {
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .ENGLISH_AUCTION) + "s") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        if currentUser == nil {
            currentUser = try await UserViewModel().getUserByEmail(username: UserDefaults.standard.string(forKey: "Username")!)
        }
        
        let user = currentUser!


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

                var temp = try decoder.decode([EnglishAuction].self, from: data)
                
                temp.reverse()
                
                var temp2 = temp.filter { $0.sellerId == user.id}
                
                if self.currentUserEnglishAuctions != temp2 {
                    self.currentUserEnglishAuctions = temp2
                }
                
                temp.removeAll { $0.sellerId == user.id || $0.failed == true || $0.active == false}
                
                if self.englishAuctions != temp {
                    self.englishAuctions = temp
                }
                                
                print("auctions successfully retrieved!")
            } else {
                throw NSError(domain: "Descending price auctions retrieval failed", code: 0, userInfo: nil)
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error.localizedDescription)
            throw error
            
        }
    }
    
    func createInverseAuction(auction: InverseAuction) async throws -> InverseAuction {
        // Construct the URL for your signup endpoint
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .INVERSE_AUCTION)) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

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
                let auction = try decoder.decode(InverseAuction.self, from: data)
                return auction
            } else {
                // Handle unsuccessful upload (non-201 status code)
                print("auction publication failed")
                throw NSError(domain: "Auction Upload Failed", code: 0, userInfo: nil)
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error)
            throw error
        }
    }
    
    func updateInverseAuction(auction: InverseAuction) async throws -> InverseAuction {
        // Construct the URL for your signup endpoint
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .INVERSE_AUCTION) + "/" + auction.id!.description) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

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
            // Perform the signup request asynchronously
            let (data, response) = try await URLSession.shared.data(for: request)

            // Handle the response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the auction information from the response data
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let auction = try decoder.decode(InverseAuction.self, from: data)
                return auction
            } else {
                // Handle unsuccessful upload (non-200 status code)
                print("auction update failed")
                throw NSError(domain: "Auction Update Failed", code: 0, userInfo: nil)
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error)
            throw error
        }
    }
    
    func getAllInverseAuctions() async throws {
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .INVERSE_AUCTION) + "s") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        if currentUser == nil {
            currentUser = try await UserViewModel().getUserByEmail(username: UserDefaults.standard.string(forKey: "Username")!)
        }
        
        let user = currentUser!


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

                var temp = try decoder.decode([InverseAuction].self, from: data)
                
                temp.reverse()
                
                var temp2 = temp.filter { $0.sellerId == user.id}
                
                if self.currentUserInverseAuctions != temp2 {
                    self.currentUserInverseAuctions = temp2
                }
                
                temp.removeAll { $0.sellerId == user.id || $0.failed == true || $0.active == false}
                
                if self.inverseAuctions != temp {
                    self.inverseAuctions = temp
                }
                
                print("auctions successfully retrieved!")
            } else {
                throw NSError(domain: "Descending price auctions retrieval failed", code: 0, userInfo: nil)
            }
        } catch {
            // Handle any errors that occurred during the request
            print("generic error")
            print(error.localizedDescription)
            throw error
            
        }
    }
    
    func deleteAuction(auction: Auction) async throws -> Bool {
        // Construct the URL for your signup endpoint
        guard let url = URL(string: Constants.BASE_URL + Constants.getEndpoint(endpoint: .DELETE_AUCTION) + auction.id!.description) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called delete auction")
        
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
            let (_, response) = try await URLSession.shared.data(for: request)

            // Handle the response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("deleted")
                return true
            } else {
                // Handle unsuccessful upload (non-200 status code)
                print("auction deletion failed")
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
