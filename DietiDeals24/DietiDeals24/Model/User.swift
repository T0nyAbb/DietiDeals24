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
    let username: String
    let password: String?
    let bio: String?
    let website: String?
    let social: String?
    let google: String?
    let facebook: String?
    let apple: String?
    let profilePicture: String?
    let iban: String?
    let vatNumber: String?
    let nationalInsuranceNumber: String?
    
    init(firstName: String?, lastName: String?, username: String, password: String?, bio: String?, website: String?, social: String?, google: String?, facebook: String?, apple: String?, profilePicture: String?, iban: String?, vatNumber: String?, nationalInsuranceNumber: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.password = password
        self.bio = bio
        self.website = website
        self.social = social
        self.google = google
        self.facebook = facebook
        self.apple = apple
        self.profilePicture = profilePicture
        self.iban = iban
        self.vatNumber = vatNumber
        self.nationalInsuranceNumber = nationalInsuranceNumber
    }
}
