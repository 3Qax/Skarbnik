//
//  ShouldChangePasswordAfterFirstLoginProtocool.swift
//  skarbnik
//
//  Created by Jakub Towarek on 01/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

protocol ChangePasswordProtocool {
    func didTappedChangePasswordButton(password: String?, repeatedPassword: String?)
}
