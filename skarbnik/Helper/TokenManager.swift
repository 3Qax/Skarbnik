//
//  TokenManager.swift
//  skarbnik
//
//  Created by Jakub Towarek on 10/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation



class TokenManager {
  
    static let shared = TokenManager()
    private var token: String {
        didSet {
            UserDefaults.standard.set(token, forKey: "JWT")
        }
    }
    private var isAuthorised = false
    private var claimsData: ClaimsData?
    
    struct ClaimsData: Codable {
        let user_id: Int
        let username: String
        let exp: Int
        let email: String
    }
    
    enum ClaimsOfInt {
        case user_id
        case exp
    }
    
    enum ClaimsOfString {
        case username
        case email
    }
    
    enum Result<T> {
        case success(T)
        case notAuthorised
    }
    
    private init() {
        if let token = UserDefaults.standard.string(forKey: "JWT") {
            self.token = token
        } else {
            self.token = ""
        }
        
    }
    
    func getToken() -> String {
        return token
    }
    
    func get(_ claim: ClaimsOfInt) -> Result<Int> {
        if let claimsData = claimsData {
            switch claim {
            case .user_id:
                return .success(claimsData.user_id)
            case .exp:
                return .success(claimsData.exp)
            }
        } else {
            return .notAuthorised
        }
    }
    
    func get(_ claim: ClaimsOfString) -> Result<String> {
        if let claimsData = claimsData {
            switch claim {
            case .username:
                return .success(claimsData.username)
            case .email:
                return .success(claimsData.email)
            }
        } else {
            return .notAuthorised
        }
    }
    
    func authorise(with newToken: String) {
        isAuthorised = true
        token = newToken
        
        let firstDot = token.range(of: ".")
        let withoutHeader = token[firstDot!.upperBound..<token.endIndex]
        
        let secondDot = withoutHeader.range(of: ".")
        let payload = withoutHeader[..<secondDot!.lowerBound]
        
        //Foundation implementation of base64 is so stupid that it can't calculate missing bits...
        let correctedPayload: String = payload.padding(toLength: ((payload.count+3)/4)*4,
                                                       withPad: "=",
                                                       startingAt: 0)
        
        
        let data = Data(base64Encoded: correctedPayload)!
        claimsData = try! JSONDecoder().decode(ClaimsData.self, from: data)
    }
    
    func deauthorise() {
        isAuthorised = false
        token = ""
        claimsData = nil
    }
}
