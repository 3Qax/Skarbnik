//
//  ShouldChangePasswordAfterFirstLoginViewController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 01/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit

class ShouldChangePasswordAfterFirstLoginViewController: UIViewController {

    override func loadView() {
        let view = ShouldChangePasswordAfterFirstLoginView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
extension ShouldChangePasswordAfterFirstLoginViewController: ShouldChangePasswordAfterFirstLoginProtocool {
    func didTappedChangePasswordButton(password: String?, repeatedPassword: String?) {
        print("Password: \(String(describing: password)), \(String(describing: repeatedPassword))")
    }
}
