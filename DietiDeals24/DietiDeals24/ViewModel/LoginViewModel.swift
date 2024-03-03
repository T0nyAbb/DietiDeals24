//
//  LoginViewModel.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 13/01/24.
//

import SwiftUI
import GoogleSignIn
import FBSDKLoginKit


class LoginViewModel: ObservableObject {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Published var googleName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isGoogleLogged: Bool = false
    @Published var errorMessage: String = ""
    @Published var googleEmail: String = ""
    @Published var fbName: String = ""
    @Published var fbProfilePicUrl: String = ""
    @Published var fbIsLogged: Bool = false
    @Published var fbEmail: String = ""
    @Published var logged: Bool = false
    @Published var appleName: String = ""
    @Published var appleIsLogged: Bool = false
    @Published var appleEmail: String = ""
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    
    
    static let shared: LoginViewModel = LoginViewModel()
    
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
            self.googleName = name ?? ""
            self.profilePicUrl = profilePicUrl
            self.isGoogleLogged = true
            self.logged = true
            self.googleEmail = email
        }else{
            self.isGoogleLogged = false
            if !self.fbIsLogged && !self.appleIsLogged {
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
    
    func checkAppleLogin() {
        guard
            let email = UserDefaults.standard.string(forKey: "AppleEmail"),
            let name = UserDefaults.standard.string(forKey: "AppleName"),
            let surname = UserDefaults.standard.string(forKey: "AppleSurname")
        else { return }
        print("Checking apple login")
        self.appleEmail = email
        self.appleName = name.appending(" ").appending(surname)
        self.appleIsLogged = true
        self.logged = true
    }
    
    func appleSignOut() {
        self.logged = false
        self.appleIsLogged = false
        self.appleName = ""
        self.appleEmail = ""
    }
    
    func userDetails() -> some View {
            AsyncImage(url: URL(string: profilePicUrl))
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
    }
    
    func userName() -> Text {
        return Text(self.googleName)
    }
    
    func getEmail() -> Text {
        return Text(self.googleEmail)
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
        if !self.isGoogleLogged && !self.fbIsLogged && !self.appleIsLogged {
            self.logged = false
        }
    }
    
    func setFbName(name: String) {
        self.fbName = name
    }
    
    func setFbPic(pic: String) {
        self.fbProfilePicUrl = pic
    }
    
    func getAppleEmail() -> Text {
        return Text(self.appleEmail)
    }
    
    func getAppleName() -> Text {
        return Text(self.appleName)
    }
    
    // Example async login function
    func login(email: String, password: String) async throws -> User {
        // Construct the URL for your login endpoint
        guard let url = URL(string: "http://localhost:8080/users/login") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        print("called login func with email: \(email) passw: \(password)")

        // Create the login request body
        let requestBody = LoginRequestBody(email: email, password: password)

        // Serialize the request body to JSON
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            print("encoding error")
            throw NSError(domain: "JSON Encoding Error", code: 0, userInfo: nil)
        }
        print(jsonData)
        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            // Perform the login request asynchronously
            let (data, response) = try await URLSession.shared.data(for: request)

            // Handle the response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the user information from the response data
                let user = try JSONDecoder().decode(User.self, from: data)
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


/// MARK: - FBLogin

struct FBLog: UIViewRepresentable {

    var loginVm: LoginViewModel = LoginViewModel.shared
    
    
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
                                               
                                               print(self.parent.loginVm.googleEmail)
                                               self.parent.loginVm.setFbEmail(email: email)
                                           }
                                           
                                           if let name: String = dictData["name"] as? String
                                           {
                                               self.parent.loginVm.setFbName(name: name)
                                           }
                                           if let id: String = dictData["id"] as? String
                                           {
                                               print("printing image url: ")
                                               print("https://graph.facebook.com/\(id)/picture?type=large&redirect=true&width=100&height=100")
                                               self.parent.loginVm.setFbPic(pic: "https://graph.facebook.com/\(id)/picture?type=large&redirect=true&width=100&height=100")
                                           }
                                           self.parent.loginVm.setFbIsLogged(isLogged: true)
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
            self.parent.loginVm.setFbIsLogged(isLogged: false)
        }
        
        
    }
}