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
    var asyncSafetyController: AsyncSafetyController?
    
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController.pushViewController(loginVC, animated: false)
    }
    
    func didLoginSuccessfully() {
        navigationController.navigationBar.isHidden = true
        let pickStudentVC = PickStudentAlertController()
        pickStudentVC.coordinator = self
        pickStudentVC.modalPresentationStyle = .overCurrentContext
        navigationController.present(pickStudentVC, animated: true)
    
        asyncSafetyController = AsyncSafetyController()
        asyncSafetyController!.coordinator = self
    }
    
    func didRequestStudentChange() {
        navigationController.navigationBar.isHidden = true
        let pickStudentVC = PickStudentAlertController()
        pickStudentVC.coordinator = self
        pickStudentVC.modalPresentationStyle = .overCurrentContext
        navigationController.present(pickStudentVC, animated: true)
    }
    
    func didChooseStudent(of studentID: Int, in classID: Int) {
        navigationController.dismiss(animated: true) {
            let paymentVC = PaymentViewController(of: studentID, in: classID)
            paymentVC.coordinator = self
            self.navigationController.pushViewController(paymentVC, animated: true)
        }
    }
    
    func shouldChangePassword() {
        let compulsoryPasswordChangeAlertController = CompulsoryPasswordChangeAlertController()
        compulsoryPasswordChangeAlertController.coordinator = self
        compulsoryPasswordChangeAlertController.modalPresentationStyle = .overCurrentContext
        navigationController.present(compulsoryPasswordChangeAlertController, animated: true)
        //User is forced to change password by
    }
    

    func shouldWarnAboutLastLogin(on date: String, from ip: String) {
        let lastLoginAttemptFailedAlertControler = LastLoginAttemptFailedAlertControler(when: date, from: ip)
        lastLoginAttemptFailedAlertControler.coordinator = self
        lastLoginAttemptFailedAlertControler.modalPresentationStyle = .overCurrentContext
        navigationController.present(lastLoginAttemptFailedAlertControler, animated: true)
        //User have two options: dismiss that information or decide to change their password - call didRequestPasswordChange()
    }
    
    func didRequestPasswordChange() {
        let changePasswordVC = ChangePasswordViewController()
        changePasswordVC.coordinator = self
        self.navigationController.pushViewController(changePasswordVC, animated: true)
    }
    
    func didChangedPassword() {
        shouldLogOut()
    }
    
    func shouldLogOut() {
        TokenManager.shared.deauthorise()
        navigationController.popToRootViewController(animated: true)
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController.pushViewController(loginVC, animated: false)
    }
    
    func didRequestReminder(about paymentName: String, ending endDate: Date) {
        let reminderController = ReminderViewController(about: paymentName, ending: endDate)
        reminderController.coordinator = self
        navigationController.pushViewController(reminderController, animated: true)
    }
    
    func didAddReminder() {
        navigationController.popViewController(animated: true)
    }
    
    func didCancelAddingReminder() {
        navigationController.popViewController(animated: true)
    }
    
    func didRequestToPay(for name: String, total: Float, remittances: [Float], currencyFormatter: NumberFormatter) {
        let payViewController = PayViewController(for: name, total: total, remittances: remittances, currencyFormatter: currencyFormatter)
        payViewController.coordinator = self
        navigationController.pushViewController(payViewController, animated: true)
        
    }
    
    
}
