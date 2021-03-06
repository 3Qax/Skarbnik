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
    let changePasswordView = ChangePasswordView()
    var coordinator: LoginCoordinator?

    override func loadView() {
        self.view = changePasswordView
        changePasswordView.delegate = self
        changePasswordView.oldPasswordInput.delegate = self
        changePasswordView.newPasswordInput.delegate = self
        changePasswordView.repeatNewPasswordInput.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ChangePasswordViewController: ChangePasswordProtocool {
    func didTappedChangePasswordButton(old: String?, new: String?, repeatedNew: String?) {
        selectionFeedbackGenerator.selectionChanged()
        changePasswordView.startWaitingAnimation()
        changePasswordModel.changePassword(old: old, new: new, new: repeatedNew) { (result) in
            DispatchQueue.main.async {
                self.changePasswordView.stopAnimating()
                switch result {
                case .success:
                    notificationFeedbackGenerator.notificationOccurred(.success)
                    self.coordinator?.shouldLogOut()
                    
                case .failure(let failType):
                    notificationFeedbackGenerator.prepare()
                    switch failType {
                    case .incorrectOldPassword:
                        AlertBuilder()
                            .basicAlert(withTitle: NSLocalizedString("failure_incorrect_old_password_title", comment: ""))
                            .setMessage(NSLocalizedString("failure_incorrect_old_password_description", comment: ""))
                            .addAction(withStyle: .default, text: "OK")
                            .show(in: self, animated: true)
                        notificationFeedbackGenerator.notificationOccurred(.warning)
                    case .passwordsDontMatch:
                        AlertBuilder()
                            .basicAlert(withTitle: NSLocalizedString("failure_passwords_dont_match_title", comment: ""))
                            .setMessage(NSLocalizedString("failure_passwords_dont_match_description", comment: ""))
                            .addAction(withStyle: .default, text: "OK")
                            .show(in: self, animated: true)
                        notificationFeedbackGenerator.notificationOccurred(.warning)
                    case .passwordDoesntSatisfyRequirements:
                        AlertBuilder()
                            .basicAlert(withTitle: NSLocalizedString("failure_password_doesnt_satisfy_requirements_title", comment: ""))
                            .setMessage(NSLocalizedString("failure_password_doesnt_satisfy_requirements_description", comment: ""))
                            .addAction(withStyle: .default, text: "OK")
                            .show(in: self, animated: true)
                        notificationFeedbackGenerator.notificationOccurred(.warning)
                    case .passwordCanNotBeEmpty:
                        AlertBuilder()
                            .basicAlert(withTitle: NSLocalizedString("failure_password_can_not_be_empty_title", comment: ""))
                            .setMessage(NSLocalizedString("failure_password_can_not_be_empty_description", comment: ""))
                            .addAction(withStyle: .default, text: "OK")
                            .show(in: self, animated: true)
                        notificationFeedbackGenerator.notificationOccurred(.warning)
                    }
                }
            }
        }
    }
    
    func reloadMe() {
        loadView()
    }
    
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == changePasswordView.oldPasswordInput {
            changePasswordView.oldPasswordInput.resignFirstResponder()
            changePasswordView.newPasswordInput.becomeFirstResponder()
        }
        if textField == changePasswordView.newPasswordInput {
            changePasswordView.newPasswordInput.resignFirstResponder()
            changePasswordView.repeatNewPasswordInput.becomeFirstResponder()
        }
        if textField == changePasswordView.repeatNewPasswordInput {
            changePasswordView.repeatNewPasswordInput.resignFirstResponder()
            changePasswordView.changePasswordButtonTapped(sender: changePasswordView.changePasswordButton)
        }
        return true
    }
    
}
