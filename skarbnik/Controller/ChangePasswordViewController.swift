//
//  ShouldChangePasswordAfterFirstLoginViewController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 01/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    let changePasswordModel = ChangePasswordModel()
    var coordinator: MainCoordinator?

    override func loadView() {
        self.view = ChangePasswordView()
        (self.view as! ChangePasswordView).delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
extension ChangePasswordViewController: ChangePasswordProtocool {
    func didTappedChangePasswordButton(old: String?, new: String?, repeatedNew: String?) {
        changePasswordModel.changePassword(old: old, new: new, new: repeatedNew) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.coordinator?.didChangedPassword()
                case .failure(let failType):
                    switch failType {
                    case .incorrectOldPassword:
                        print("old password wrong")
                    case .passwordsDontMatch:
                        print("passowrds dont match each other")
                    case .passwordDoesntSatisfyRequirements:
                        print("password doesnt fullfil requirements")
                    }
                }
            }
        }
    }
    
    func reloadMe() {
        loadView()
    }
    
}
