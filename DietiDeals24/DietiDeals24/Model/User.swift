//
//  User.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 12/01/24.
//

import Foundation

struct User: Codable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let username: String?
    let password: String?
    let bio: String?
    let website: String?
    let social: String?
    let google: String?
    let facebook: String?
    let apple: String?
    let profilePicture: String?
    
    
    init(firstName: String?, lastName: String?, email: String?, username: String?, password: String?, bio: String?, website: String?, social: String?, google: String?, facebook: String?, apple: String?, profilePicture: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.username = username
        self.password = password
        self.bio = bio
        self.website = website
        self.social = social
        self.google = google
        self.facebook = facebook
        self.apple = apple
        self.profilePicture = profilePicture
    }
}
