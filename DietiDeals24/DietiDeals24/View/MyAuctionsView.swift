//
//  MyAuctionsView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 22/01/24.
//

import SwiftUI

struct MyAuctionsView: View {
    
    var userVm: UserViewModel
    @ObservedObject var loginVm: LoginViewModel
    @State private var user: User?
    
    var body: some View {
        NavigationView {
            VStack {
                    Text(user?.username ?? "Username")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                    HStack {
                        Text(user?.firstName ?? "FirstName")
                        Text(user?.lastName ?? "LastName")
                    
                    
                }
            }
            .navigationTitle("My Auctions")
            .task {
                do {
                    user = try await userVm.getUserByEmail(username: loginVm.email)
                } catch UserError.invalidURL {
                    print("Invalid URL")
                } catch UserError.invalidResponse {
                    print("Invalid response")
                } catch UserError.invalidData {
                    print("Invalid data")
                } catch {
                    print("Generic error")
                }
            }
            .refreshable {
                do {
                    user = try await userVm.getUserByEmail(username: loginVm.email)
                } catch {
                    print("Error")
                }
                
            }
        }
    }
}

#Preview {
    MyAuctionsView(userVm: UserViewModel(), loginVm: LoginViewModel.shared)
}
