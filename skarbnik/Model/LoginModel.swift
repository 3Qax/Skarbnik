//
//  LoginModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 03/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

class LoginModel {
    let apiClient = APIClient()
    
    struct LoginPacket: Codable {
        let username: String
        let password: String
    }
    
    typealias LoginWithTokenPacket = ResponsePacket
    struct ResponsePacket: Codable {
        let token: String
    }
    
    func encode<T: Encodable>(_ data: T) -> Data {
        return try! JSONEncoder().encode(data)
    }
    
    func decode<T: Decodable>(_: T.Type, from data: Data) -> T {
        return try! JSONDecoder().decode(T.self, from: data)
    }
    
    
    
    func login(completion: @escaping (Bool) -> ()) {
        guard UserDefaults.standard.string(forKey: "JWT") != nil, UserDefaults.standard.string(forKey: "JWT") != "" else {
            completion(false)
            return
        }
    
        let loginPacket = LoginWithTokenPacket(token: UserDefaults.standard.string(forKey: "JWT")!)
        apiClient.request(.refresh, data: encode(loginPacket)) { (successful, recivedData) in
            if successful {
                if let recivedData = recivedData {
                    let recivedToken: ResponsePacket = self.decode(ResponsePacket.self,from: recivedData)
                    UserDefaults.standard.set(recivedToken.token, forKey: "JWT")
                } else {
                    print("Even thought login was successful cannot save recived token")
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func login(login: String?, password: String?, completion: @escaping (Bool) -> ()) {
        if let login = login, let password = password {
            if login != "" && password != "" {
                apiClient.request(.login, data: encode(LoginPacket(username: login, password: password))) { (successful, recivedData) in
                    if successful {
                        if let recivedData = recivedData {
                            let recivedToken: ResponsePacket = self.decode(ResponsePacket.self,from: recivedData)
                            UserDefaults.standard.set(recivedToken.token, forKey: "JWT")
                        } else {
                            print("Even thought login was successful cannot save recived token")
                        }
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } else {
                print("Empty login or password")
            }
        } else {
            print("Login or password are nil")
        }
    }
}
