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
            //TODO: create modal pop-up telling that user must change a password
            let ChangePasswordVC = ChangePasswordViewController()
            navigationController.pushViewController(ChangePasswordVC, animated: true)
            return
        }
        let pickStudentVC = PickStudentViewController()
        pickStudentVC.modalPresentationStyle = .overCurrentContext
        pickStudentVC.coordinator = self
        navigationController.present(pickStudentVC, animated: true)
    }
    
    func didRequestStudentChange() {
        let pickStudentVC = PickStudentViewController()
        pickStudentVC.coordinator = self
        navigationController.pushViewController(pickStudentVC, animated: false)
    }
    
    func didChooseStudent(with id: Int) {
        let paymentVC = PaymentViewController(of: id)
        paymentVC.coordinator = self
        navigationController.pushViewController(paymentVC, animated: true)
    }
}
