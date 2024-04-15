//
//  FieldChecker.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 15/03/24.
//

import Foundation

class FieldChecker {
    
    func checkFields(username: String?, password: String?, confirmPassword: String?, iban: String?) throws -> Bool {
        //Email regex
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        //Password Regex
        let numberRegex  = ".*[0-9]+.*"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", numberRegex)
        //IBAN Regex
        let ibanRegex = #"^[a-zA-Z]{2}\d+$"#
        let ibanPredicate = NSPredicate(format: "SELF MATCHES %@", ibanRegex)
        
        //A required field is null
        if(username == nil || password == nil || confirmPassword == nil || iban == nil) {
            throw UserError.invalidFields
        }
        
        //A required field is empty
        if(username!.isEmpty || password!.isEmpty || confirmPassword!.isEmpty || iban!.isEmpty) {
            return false
        }
        
        //Email not matching regex
        if(!emailPredicate.evaluate(with: username)) {
            return false
        }
        
        //Password shorter than 5 characters
        if(password!.count < 5) {
            return false
        }
        
        //Password not containing a number
        if(!passwordPredicate.evaluate(with: password)) {
            return false
        }
        
        //Password and confirmPassword don't match
        if(password != confirmPassword) {
            return false
        }
        
        //IBAN is less than 15 characters or longer than 30 characters
        if(iban!.count < 15 || iban!.count > 30) {
            return false
        }
        
        //IBAN doesn't start with 2 letters and the rest are all numbers
        if(!ibanPredicate.evaluate(with: iban)) {
            return false
        }
        
        return true
    }

}
