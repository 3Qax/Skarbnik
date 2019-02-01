//
//  ShouldChangePasswordAfterFirstLoginProtocool.swift
//  skarbnik
//
//  Created by Jakub Towarek on 01/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

protocol ShouldChangePasswordAfterFirstLoginProtocool {
    func didTappedChangePasswordButton(password: String?, repeatedPassword: String?)
}
