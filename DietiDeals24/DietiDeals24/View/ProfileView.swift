//
//  ProfileView.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 22/01/24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit

struct ProfileView: View {
    @StateObject var loginVm: LoginViewModel
    var userVm: UserViewModel = UserViewModel()
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var vm = GoogleSignInButtonViewModel()
    @State var fbLogged: Bool = AccessToken.isCurrentAccessTokenActive
    @State var googleLogged: Bool = GIDSignIn.sharedInstance.currentUser != nil
    @Environment(\.dismiss) var dismiss
    @State var loggedOut: Bool = false
    @State var appleLogged: Bool = LoginViewModel.shared.appleIsLogged
    @State var isPresented = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var uiImage: UIImage?
    var imageViewModel = ImageViewModel()
    
    
    
    var body: some View {
            NavigationView {
                VStack {
                    if fbLogged {
                        loginVm.getfbImage()
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        Text(loginVm.getfbName())
                        Text(loginVm.fbEmail)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        FBLog(loginVm: loginVm)
                            .frame(height: 45)
                        if !AccessToken.isCurrentAccessTokenActive {
                            let _ = print("logged out from fb")
                            let _ = loggedOut = true
                            let _ = dismiss()
                        }
                    }
                    else if googleLogged {
                        
                        loginVm.userDetails()
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        loginVm.getGoogleUserName()
                        loginVm.getGoogleEmail()
                            .padding()
                        Button(action: {
                            authViewModel.signOut()
                            loggedOut = true
                            dismiss()
                        }) {
                            Text("Sign Out")
                        }
                    }
                    
                    else if appleLogged {
                        AsyncImage(url: URL(string: loginVm.user?.profilePicture ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 125, height: 125)
                        } placeholder: {
                            Image(systemName: "person.circle")
                                .font(.system(size: 100))
                                .frame(width: 100, height: 100)
                        }
                        Button("Modify") {
                            isPresented = true
                        }
                        loginVm.getAppleName()
                        loginVm.getAppleEmail()
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .padding()
                        Button(action: {
                            loginVm.appleSignOut()
                            loggedOut = true
                            dismiss()
                        }) {
                            Text("Sign Out")
                        }
                    }
                    else if loginVm.checkLogin() {
                        if let imageURL = loginVm.user?.profilePicture {
                            AsyncImage(url: URL(string: imageURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 125, height: 125)
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image(systemName: "person.circle")
                                .font(.system(size: 100))
                                .frame(width: 100, height: 100)
                        }
                        Button("Modify") {
                            isPresented = true
                        }
                        Divider()
                            .padding()
                        loginVm.getName()
                            .font(.title)
                            .bold()
                        Divider()
                        loginVm.getEmail()
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .padding()
                        Spacer()
                        Button(action: {
                            loginVm.signOut()
                            loggedOut = true
                            dismiss()
                        }) {
                            Text("Sign Out")
                                .bold()
                                .frame(width: 360, height: 45)
                                .background(Color.red.gradient)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding()
                        }
                    } else {
                        Button(action: {
                            loginVm.signOut()
                            loggedOut = true
                            dismiss()
                        }) {
                            Text("Sign Out")
                                .bold()
                                .frame(width: 360, height: 45)
                                .background(Color.red.gradient)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                }
                .navigationTitle("Profile")
            }
            .sheet(isPresented: $isPresented, content: {
                ImagePicker(uiImage: $uiImage, isPresenting: $isPresented, sourceType: $sourceType)
                    .onDisappear {
                        if uiImage != nil {
                            imageViewModel.uiImage = self.uiImage
                            Task {
                                let image = try await imageViewModel.uploadProfilePicture(username: loginVm.user!.username)
                                print("image saved: \(image)")
                                let imageUrl = try await imageViewModel.getProfilePictureUrl(username: image)
                                print("image url saved: \(imageUrl)")
                                loginVm.user?.profilePicture = imageUrl
                                print("updated user pfp")
                                loginVm.user = try await userVm.updateUser(user: loginVm.user!)
                                print("updated user in db!")
                            }
                            
                        }
                    }
            })

            
        }
    
        
}

#Preview {
    ProfileView(loginVm: LoginViewModel.shared)
}
