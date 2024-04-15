//
//  User.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 12/01/24.
//

import Foundation

struct User: Codable {
    let id: Int?
    var firstName: String?
    var lastName: String?
    var username: String
    var password: String?
    var bio: String?
    var website: String?
    var social: String?
    var geographicArea: String?
    var google: String?
    var facebook: String?
    var apple: String?
    var profilePicture: String?
    var iban: String?
    var vatNumber: String?
    var nationalInsuranceNumber: String?

    init(id: Int?, firstName: String?, lastName: String?, username: String, password: String?, bio: String?, website: String?, social: String?, geographicArea: String?, google: String?, facebook: String?, apple: String?, profilePicture: String?, iban: String?, vatNumber: String?, nationalInsuranceNumber: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.password = password
        self.bio = bio
        self.website = website
        self.social = social
        self.geographicArea = geographicArea
        self.google = google
        self.facebook = facebook
        self.apple = apple
        self.profilePicture = profilePicture
        self.iban = iban
        self.vatNumber = vatNumber
        self.nationalInsuranceNumber = nationalInsuranceNumber
    }
}
