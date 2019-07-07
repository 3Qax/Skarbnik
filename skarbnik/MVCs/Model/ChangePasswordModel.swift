//
//  ChangePasswordModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 09/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation


enum PasswordChangingResult {
    case success
    case failure(ChangingPasswordEnum)
    
    enum ChangingPasswordEnum {
        case passwordCanNotBeEmpty
        case incorrectOldPassword
        case passwordsDontMatch
        case passwordDoesntSatisfyRequirements
    }
}

class ChangePasswordModel {
    private let semaphore = DispatchSemaphore(value: 0)
    private struct ChangePasswordPacket: Codable {
        let old_password: String
        let new_password: String
    }

    

 
    func encode<T: Encodable>(_ data: T) -> Data {
        return try! JSONEncoder().encode(data)
    }
    
    func decode<T: Decodable>(_: T.Type, from data: Data) -> T {
        return try! JSONDecoder().decode(T.self, from: data)
    }
    
    private func does(_ first: String, match secound: String) -> Bool {
        if first == secound { return true }
        return false
    }
    
    private func doesSatisfyRequirements(_ password: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\\$%\\^&\\*.,:;\\[\\]])(?=.{8,})")
        let matches = regex.firstMatch(in: password, range: NSRange(location: 0, length: password.count))
        if matches != nil {
            return true
        }
        return false
    }
    
    func changePassword(old oldPassword: String?, new newPassword: String?, new repeatedNewPassword: String?, completion: @escaping (PasswordChangingResult) -> ()) {
        guard oldPassword != nil, newPassword != nil, repeatedNewPassword != nil else {
            completion(.failure(.passwordCanNotBeEmpty))
            return
        }
        guard oldPassword != "", newPassword != "", repeatedNewPassword != "" else {
            completion(.failure(.passwordCanNotBeEmpty))
            return
        }
        guard doesSatisfyRequirements(newPassword!) else  {
            completion(.failure(.passwordDoesntSatisfyRequirements))
            return
        }
        guard does(newPassword!, match: repeatedNewPassword!) else {
            completion(.failure(.passwordsDontMatch))
            return
        }
        
        let changePasswordPacket = ChangePasswordPacket(old_password: oldPassword!, new_password: newPassword!)

        NetworkManager.shared.put(encode(changePasswordPacket), to: .changePassword) { (result: Result) in
            switch result {
            case .success:
                completion(.success)
            case .failure:
                completion(.failure(.incorrectOldPassword))
            }
        }
    }
}
