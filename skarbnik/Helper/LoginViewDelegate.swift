//
//  LoginViewDelegate.swift
//  skarbnik
//
//  Created by Jakub Towarek on 11/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

protocol LoginViewDelegate {
    func tryToLoginWith(login: String?, pass: String?) -> Void
    func didTappedOutside() -> Void
}
