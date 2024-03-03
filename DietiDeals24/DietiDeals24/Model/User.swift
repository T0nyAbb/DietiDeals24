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
    let webSites: String?
    let socials: String?
    
    
    init(firstName: String?, lastName: String?, email: String, username: String?, password: String?, bio: String?, webSites: String?, socials: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.username = username
        self.password = password
        self.bio = bio
        self.webSites = webSites
        self.socials = socials
    }
    
    
    
    
}
