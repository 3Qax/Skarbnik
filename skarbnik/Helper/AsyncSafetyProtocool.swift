//
//  AsyncPasswordProtocool.swift
//  skarbnik
//
//  Created by Jakub Towarek on 06/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

protocol AsyncSafetyProtocool: class {
    func requirePasswordChange()
    func lastLoginUnsuccessful(_ date: Date, fromIP ip: String)
    func dontRequirePasswordChange()
    func lastLoginSuccessful()
}
