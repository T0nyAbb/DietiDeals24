//
//  StringLocalizationExtension.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 07/04/24.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment:"")
    }
}
