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
    var isLoggedIn = false
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
        
        let token = TokenManager.shared.getToken()
        if token == "" {
            completion(false)
            return
        }
        
        NotificationCenter.default.post(name: .setStatus, object: nil, userInfo: ["status":"Przywracanie sesji..."])
        
        let loginPacket = LoginWithTokenPacket(token: token)

        apiClient.post(encode(loginPacket), to: .refresh) { (result: APIClient.Result<ResponsePacket>) in
            switch result {
            case .success(let recivedToken):
                TokenManager.shared.authorise(with: recivedToken.token)
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func login(login: String?, password: String?, completion: @escaping (Bool) -> ()) {
        
        guard let login = login, let password = password else {
            completion(false)
            return
        }
        
        guard login != "" && password != "" else {
            completion(false)
            return
        }
        
        apiClient.post(encode(LoginPacket(username: login, password: password)), to: .login) { (result: APIClient.Result<ResponsePacket>) in
            switch result {
            case .success(let recivedToken):
                TokenManager.shared.authorise(with: recivedToken.token)
                self.isLoggedIn = true
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    
    
}
