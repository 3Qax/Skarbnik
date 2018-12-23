//
//  loginModel.swift
//  skarbinik
//
//  Created by Jakub Towarek on 24/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import Foundation


struct LoginResponse: Codable {
    var JWT: String?
}
class UserSetupPacket: Codable {
    var password, email: String
    var JWT: String
}
