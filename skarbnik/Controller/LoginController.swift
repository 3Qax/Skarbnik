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
    
    func handleLoginResponse(haveUsedToken: Bool, response: HTTPURLResponse, data: Data){
        if response.statusCode==200 {
            print("Response 200 OK:")
            //poprawnie zalogowano
                //jeśli odpowedź zawiera token to go zapisz
                let JWT:Token = try! JSONDecoder().decode(Token.self, from: data)
                print("\tSaving: \(JWT)")
                UserDefaults.standard.set(JWT.token, forKey: "JWT")
            
                //sprawdźić czy to jest pierwsze zalogowanie
                //jeśli tak wświetlić ekran wymagający zmianę hasła
            
                loginCompletion?(true)
        } else if response.statusCode==400 && !haveUsedToken{
            SCLAlertView().showError("Błąd", subTitle: "Niepoprawne dane logowania", closeButtonTitle: "OK")
            loginCompletion?(false)
        } else if response.statusCode==400 {
            print("\tIncorrect or outdated token")
            loginCompletion?(false)
        } else {
            print("\tHTTP Error: \(response.statusCode)")
            loginCompletion?(false)
        }
    }
    
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
    
    //This method tries to log in with given login and password
    func login(login: String?, password: String?, completition: @escaping (Bool) -> ()) {
        
        loginCompletion = completition
        
        if let login = login, let password = password {
            
            if login != "" && password != "" {
                
                let loginObject = LoginPacket(username: login, password: password)
                
                //tworzenia URL
                destinationURL.scheme = "https"
                destinationURL.host = "quiet-caverns-69534.herokuapp.com"
                destinationURL.port = 443
                destinationURL.path = "/api/users/login"
                print("URL: \(String(describing: destinationURL.url))")
                
                //tworzenie URLRequest bazująze na URL
                let request:URLRequest! = {
                   var request = URLRequest(url: destinationURL.url!)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = try! JSONEncoder().encode(loginObject)
                    print(String(data: request.httpBody!, encoding: String.Encoding.utf8) as Any)
                    return request
                }()
                let task = session.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        SCLAlertView().showError("Błąd", subTitle: "\(error.localizedDescription)", closeButtonTitle: "nah")
//                        DispatchQueue.main.async(execute: {
//                                print(error.localizedDescription)
//
//                            })
                    } else {
                        if let data = data, let response = response as? HTTPURLResponse {
                            DispatchQueue.main.async(execute: { self.handleLoginResponse(haveUsedToken: false, response: response, data: data) })
                        }
                    }
                }
                task.resume()
            } else {
                DispatchQueue.main.async(execute: { SCLAlertView().showError("Błąd", subTitle: "Uzupełnij wszstkie pola", closeButtonTitle: "OK") })
            }
        }
    }
    
    //This method tries to log in with localy stored JWT
    func login(completion: @escaping (Bool) -> ()) {
        
        loginCompletion = completion
        
        //sprawdzenie czy token istnieje
        if let JWT: String = UserDefaults.standard.string(forKey: "JWT")
        {
            //tworzenia URL
            destinationURL.scheme = "https"
            destinationURL.host = "quiet-caverns-69534.herokuapp.com"
            destinationURL.port = 443
            destinationURL.path = "/api/users/refresh"
            print("Found a token. Trying to authoritize: \n\tURL: \(String(describing: destinationURL.url))")
        
            //tworzenie URLRequest bazująze na URL
            let request:URLRequest! = {
                var request = URLRequest(url: destinationURL.url!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try! JSONEncoder().encode(Token(token: JWT))
                print("\tBody: \(String(data: request.httpBody!, encoding: String.Encoding.utf8)!)")//String(data: request.httpBody!, encoding: String.Encoding.utf8) as Any)
                return request
            }()
        
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("\tError: \(error.localizedDescription)")
                    SCLAlertView().showError("Błąd", subTitle: "\(error.localizedDescription)", closeButtonTitle: "nah")
                } else {
                    if let data = data, let response = response as? HTTPURLResponse {
                        DispatchQueue.main.async(execute: { self.handleLoginResponse(haveUsedToken: true, response: response, data: data) })
                    }
                }
            }
            task.resume()
        } else {
            print("Haven't found a token.")
            loginCompletion?(false)
        }
    }

}
