//
//  GoogleSignInAuthenticator.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 12/01/24.
//

import Foundation
import SwiftUI
import GoogleSignIn

/// An observable class for authenticating via Google.
final class GoogleSignInAuthenticator: ObservableObject {
    private var authViewModel: AuthenticationViewModel
    
    /// Creates an instance of this authenticator.
    /// - parameter authViewModel: The view model this authenticator will set logged in status on.
    init(authViewModel: AuthenticationViewModel) {
        self.authViewModel = authViewModel
    }
    
    /// Signs in the user based upon the selected account.'
    /// - note: Successful calls to this will set the `authViewModel`'s `state` property.
    func signIn() {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("There is no root view controller!")
            return
        }
        let config = GIDConfiguration(clientID: "662769863779-v5244p6f58j2835l67rj7em8d1upav27.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            guard let signInResult = signInResult else {
                print("Error! \(String(describing: error))")
                return
            }
            self.authViewModel.state = .signedIn(signInResult.user)
        }
    }
    
    /// Signs out the current user.
    func signOut() {
      GIDSignIn.sharedInstance.signOut()
      authViewModel.state = .signedOut
    }

    /// Disconnects the previously granted scope and signs the user out.
    func disconnect() {
      GIDSignIn.sharedInstance.disconnect { error in
        if let error = error {
          print("Encountered error disconnecting scope: \(error).")
        }
        self.signOut()
      }
    }
    
}
