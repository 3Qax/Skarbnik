//
//  LoginCoordinator.swift
//  skarbnik
//
//  Created by Jakub Towarek on 17/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class LoginCoordinator: Coordinator {
    
    weak var parentCoordinator: MainCoordinator?
    var      children: [Coordinator] = [Coordinator]()
    var      navigationController: UINavigationController
    
    
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    
    func start() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController.pushViewController(loginVC, animated: false)
    }
    
    func didLoginSuccessfully() {
        
        let asyncSafetyController = AsyncSafetyController()
        asyncSafetyController.coordinator = self

    }
    
    func shouldChangePassword() {
        let compulsoryPCAC = CompulsoryPasswordChangeAlertController()
        compulsoryPCAC.coordinator = self
        compulsoryPCAC.modalPresentationStyle = .overCurrentContext
        navigationController.present(compulsoryPCAC, animated: true)
    }
    
    
    func shouldWarnAboutLastLogin(on date: String, from ip: String) {
        let lastLAFAC = LastLoginAttemptFailedAlertControler(when: date, from: ip)
        lastLAFAC.coordinator = self
        lastLAFAC.modalPresentationStyle = .overCurrentContext
        navigationController.present(lastLAFAC, animated: true)
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
    
    func safetyCheckEnded() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.didRequestStudentChange()
        parentCoordinator?.childDidFinish(self)
    }
    

    
    
}
