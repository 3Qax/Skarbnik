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
    
    func didLoginSuccessfully() {
        asyncPasswordController()
        let pickStudentVC = PickStudentViewController()
        pickStudentVC.modalPresentationStyle = .overCurrentContext
        pickStudentVC.coordinator = self
        navigationController.present(pickStudentVC, animated: true)
    }
    
    func asyncPasswordController() {
        func passwordChangeRequired() {
            let ChangePasswordVC = ChangePasswordViewController()
            navigationController.pushViewController(ChangePasswordVC, animated: true)
            return
        }
        
        //TODO: create modal pop-up telling that user must change a password
//        passwordChangeRequired()
    }
    

    
    func didRequestStudentChange() {
        let pickStudentVC = PickStudentViewController()
        pickStudentVC.coordinator = self
        navigationController.pushViewController(pickStudentVC, animated: false)
    }
    
    func didChooseStudent(of studentID: Int, in classID: Int) {
        let paymentVC = PaymentViewController(of: studentID, in: classID)
        paymentVC.coordinator = self
        navigationController.pushViewController(paymentVC, animated: true)
    }
}
