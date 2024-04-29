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
    @State var isPresented: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var uiImage: UIImage?
    @State var changed: Bool = false
    var imageViewModel: ImageViewModel = ImageViewModel()
    
    
    
    var body: some View {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if loginVm.checkLogin() || appleLogged || googleLogged || fbLogged {
                            ImageView(pictureUrl: loginVm.user?.profilePicture, isProfilePicture: true)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                                .shadow(radius: 7)
                                .offset(y: -50)
                                .padding(.bottom, -130)
                                .frame(width: 300, height: 300)
                                .onTapGesture {
                                isPresented = true
                            }
                            VStack(alignment: .leading) {
                                Text("\(loginVm.user?.firstName! ?? "") \(loginVm.user?.lastName! ?? "")")
                                    .font(.title)
                                HStack {
                                    Text(loginVm.user?.website ?? "No website")
                                    Spacer()
                                    Text(loginVm.user?.geographicArea ?? "Unknown")
                                }
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                Divider()
                                Text(loginVm.user?.bio ?? "No description")
                                    .padding()
                            }
                            .padding()
                                NavigationLink(destination: ModifyProfileView(user: loginVm.user!, userViewModel: userVm, changed: $changed)) {
                                    HStack {
                                        Text("Edit Profile")
                                            .frame(width: 360, height: 45)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                }
                                .isDetailLink(false)
                                .id(UUID())
                                .onAppear {
                                    if changed {
                                        loginVm.signOut()
                                        loggedOut = true
                                        dismiss()
                                    }
                                }
                            if !fbLogged {
                                Button(action: {
                                    if googleLogged {
                                        authViewModel.signOut()
                                        loginVm.signOut()
                                    }
                                    if appleLogged {
                                        loginVm.appleSignOut()
                                    }
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
                                FBLog(loginVm: loginVm)
                                    .frame(height: 45)
                                if !AccessToken.isCurrentAccessTokenActive {
                                    let _ = print("logged out from fb")
                                    let _ = loggedOut = true
                                    let _ = dismiss()
                                }
                            }
                            } else {
                                Text("")
                                    .onAppear {
                                        loginVm.signOut()
                                        loggedOut = true
                                        dismiss()
                                    }
                            }
                    }
                    .refreshable {
                        Task {
                            await loginVm.updateCurrentUser()
                        }
                    }
                }
                .navigationTitle("Profile")
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
    
        
}

#Preview {
    ProfileView(loginVm: LoginViewModel.shared)
}
