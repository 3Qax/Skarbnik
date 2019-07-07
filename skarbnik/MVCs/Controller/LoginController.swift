//
//  loginController.swift
//  skarbinik
//
//  Created by Jakub Towarek on 24/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import Foundation
import SCLAlertView



class LoginController {
    var loginCompletion: ((Bool) -> ())?
    
    var destinationURL = URLComponents()
    var session: URLSession = {
        var configuration: URLSessionConfiguration! = {
            let config = URLSessionConfiguration.ephemeral
            config.allowsCellularAccess = false
            config.waitsForConnectivity = true
            return config
        }()
        let session = URLSession(configuration: configuration)
        return session
    }()
        
    func validate(password: String?) -> Bool {
        if let password = password {
            if password != "" {
                let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\\$%\\^&\\*])(?=.{8,})")
                if passwordTest.evaluate(with: password) {
                    return true
                } else {
                    SCLAlertView().showError("Błąd", subTitle: "Hasło musi zawierać co najmniej: jedną małą i wielką literę, jedną cyfrę i znak. Minimalna długość hasła to 8 znaków.", closeButtonTitle: "OK")
                    return false
                }
            } else {
                SCLAlertView().showError("Błąd", subTitle: "Hasło nie może być puste!", closeButtonTitle: "OK")
                return false
            }
        } else {
            SCLAlertView().showError("Błąd", subTitle: "Hasło nie może być nilem!", closeButtonTitle: "OK")
            return false
        }
    }
}
