//
//  UserViewModel.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 13/01/24.
//

import SwiftUI
import GoogleSignIn
import FBSDKLoginKit

class UserViewModel: ObservableObject {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Published var name: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isLogged: Bool = false
    @Published var errorMessage: String = ""
    @Published var email: String = ""
    @Published var fbName: String = ""
    @Published var fbProfilePicUrl: String = ""
    @Published var fbIsLogged: Bool = false
    @Published var fbEmail: String = ""
    @Published var logged: Bool = false
    
    
    
    static let shared: UserViewModel = UserViewModel()
    
    private init(){
        check()
    }
    
    func checkStatus(){
        if(GIDSignIn.sharedInstance.currentUser != nil){
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            let name = user.profile?.givenName
            let profilePicUrl = user.profile!.imageURL(withDimension: 100)!.absoluteString
            let email = user.profile!.email
            self.name = name ?? ""
            self.profilePicUrl = profilePicUrl
            self.isLogged = true
            self.logged = true
            self.email = email
        }else{
            self.isLogged = false
            if !self.fbIsLogged {
                self.logged = false
            }
//            self.name = "Not Logged In"
//            self.profilePicUrl =  ""
        }
    }
    
    func check(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            
            self.checkStatus()
        }
    }
    
    func userDetails() -> some View {
            AsyncImage(url: URL(string: profilePicUrl))
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
    }
    
    func userName() -> Text {
        return Text(self.name)
    }
    
    func getEmail() -> Text {
        return Text(self.email)
    }
    
    func getfbUserDetails() -> String {
        return self.fbProfilePicUrl
    }
    
    func getfbImage() -> some View {
        AsyncImage(url: URL(string: fbProfilePicUrl))
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
    }
    
    func getfbUserName() -> String {
        return self.fbName
    }
    
    func fbGetEmail() -> String {
        return self.fbEmail
    }
    
    func setFbEmail(email: String) {
        self.fbEmail = email
    }
    
    func setFbIsLogged(isLogged: Bool) {
        self.fbIsLogged = isLogged
        if self.fbIsLogged {
            self.logged = true
        }
        if !self.isLogged && !self.fbIsLogged {
            self.logged = false
        }
    }
    
    func setFbName(name: String) {
        self.fbName = name
    }
    
    func setFbPic(pic: String) {
        self.fbProfilePicUrl = pic
    }
    
    
    
    
    
    

    
}


/// MARK: - FBLogin

struct FBLog: UIViewRepresentable {

    var userVm: UserViewModel = UserViewModel.shared
    
    
    func makeCoordinator() -> Coordinator {
        return FBLog.Coordinator(parent: self)
    }
    

    
    func makeUIView(context: Context) -> FBLoginButton {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        button.delegate = context.coordinator
        
        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {
        
    }
    
    class Coordinator: NSObject, LoginButtonDelegate {
        
        var parent: FBLog
        
        init(parent: FBLog) {
            self.parent = parent
        }
        
        
        func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
            
            
            
            if error != nil {
                
                print(error!.localizedDescription)
                return
            }
            
            if !result!.isCancelled {
                let requestMe = GraphRequest.init(graphPath: "me", parameters: ["fields" : "id,name,email,picture.type(large)"])
                
                   let connection = GraphRequestConnection()

                connection.add(requestMe, completion:{ (connectn, userresult, error) in

                       if let dictData: [String : Any] = userresult as? [String : Any]
                       {
                           print("Printing dictData: ")
                           print(dictData)
                           DispatchQueue.main.async
                               {
                                   if let pictureData: [String : Any] = dictData["picture"] as? [String : Any]
                                   {
                                       print("printing pictureData: ")
                                       print(pictureData)
                                       if let data : [String: Any] = pictureData["data"] as? [String: Any]
                                       {
                                           print("printing data: ")
                                           print(data)
                                           if let email: String = dictData["email"] as? String
                                           {
                                               
                                               print(self.parent.userVm.email)
                                               self.parent.userVm.setFbEmail(email: email)
                                           }
                                           
                                           if let name: String = dictData["name"] as? String
                                           {
                                               self.parent.userVm.setFbName(name: name)
                                           }
                                           if let id: String = dictData["id"] as? String
                                           {
                                               print("printing image url: ")
                                               print("https://graph.facebook.com/\(id)/picture?type=large&redirect=true&width=100&height=100")
                                               self.parent.userVm.setFbPic(pic: "https://graph.facebook.com/\(id)/picture?type=large&redirect=true&width=100&height=100")
                                           }
                                           self.parent.userVm.setFbIsLogged(isLogged: true)
                                           
                                           
                                           if let pictureURL = data["url"] as? String { //image url of your image
                                               print("printing url: ")
                                                print(pictureURL)
//                                                  if let url = URL(string: pictureURL) {
//                                                      print(url)
//
//                                                          if let data = try? Data(contentsOf: url) { //here you get image data from url
//
//                                                             //generate image from data and assign it to your profile imageview
//                                                             let uiImage = UIImage(data: data)
//                                                              let image = Image(uiImage: uiImage!)
//                                                          }
//                                                  }
                                           }
                                     }
                                 }
                             }
                         }
                     })
                     connection.start()
                 }
            
            
        }
        
        func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
            print("fb logged out")
            self.parent.userVm.setFbIsLogged(isLogged: false)
        }
        
        
    }
}
