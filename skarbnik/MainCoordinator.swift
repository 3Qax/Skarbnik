//
//  mainCoordinator.swift
//  skarbnik
//
//  Created by Jakub Towarek on 01/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator {
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController.pushViewController(loginVC, animated: false)
    }
    
    func didLoginSuccessfully(passwordChangeRequired: Bool) {
        if passwordChangeRequired {
            //TODO: show alert about requiring assword change
            let shouldChangePasswordAfterFirstLoginVC = ShouldChangePasswordAfterFirstLoginViewController()
            navigationController.pushViewController(shouldChangePasswordAfterFirstLoginVC, animated: true)
            return
        }
        let paymentVC = PaymentViewController()
        navigationController.pushViewController(paymentVC, animated: true)
    }
}
