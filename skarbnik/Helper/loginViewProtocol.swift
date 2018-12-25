//
//  loginDelegate.swift
//  skarbinik
//
//  Created by Jakub Towarek on 24/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import Foundation

@objc protocol LoginViewProtocol {
    @objc func tryToLoginWith(login: String?, pass: String?) -> Void
    func didTappedOutside() -> Void
}
