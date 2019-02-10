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
        (self.view as! ChangePasswordView).oldPasswordInput.delegate = self
        (self.view as! ChangePasswordView).newPasswordInput.delegate = self
        (self.view as! ChangePasswordView).repeatNewPasswordInput.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showErrorAler(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    
}
extension ChangePasswordViewController: ChangePasswordProtocool {
    func didTappedChangePasswordButton(old: String?, new: String?, repeatedNew: String?) {
        selectionFeedbackGenerator.selectionChanged()
        (self.view as! ChangePasswordView).startWaitingAnimation()
        changePasswordModel.changePassword(old: old, new: new, new: repeatedNew) { (result) in
            DispatchQueue.main.async {
                (self.view as! ChangePasswordView).stopAnimating()
                switch result {
                case .success:
                    notificationFeedbackGenerator.notificationOccurred(.success)
                    self.coordinator?.didChangedPassword()
                case .failure(let failType):
                    notificationFeedbackGenerator.prepare()
                    switch failType {
                    case .incorrectOldPassword:
                        self.showErrorAler(with: NSLocalizedString("failure_incorrectOldPassword_title", comment: ""),
                                           message: NSLocalizedString("failure_incorrectOldPassword_description", comment: ""))
                        notificationFeedbackGenerator.notificationOccurred(.warning)
                    case .passwordsDontMatch:
                        self.showErrorAler(with: NSLocalizedString("failure_passwordsDontMatch_title", comment: ""),
                                           message: NSLocalizedString("failure_passwordsDontMatch_description", comment: ""))
                        notificationFeedbackGenerator.notificationOccurred(.warning)
                    case .passwordDoesntSatisfyRequirements:
                        self.showErrorAler(with: NSLocalizedString("failure_passwordDoesntSatisfyRequirements_title", comment: ""),
                                           message: NSLocalizedString("failure_passwordDoesntSatisfyRequirements_description", comment: ""))
                        notificationFeedbackGenerator.notificationOccurred(.warning)
                    case .passwordCanNotBeEmpty:
                        self.showErrorAler(with: NSLocalizedString("failure_passwordCanNotBeEmpty_title", comment: ""),
                                           message: NSLocalizedString("failure_passwordCanNotBeEmpty_description", comment: ""))
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
        if textField == (self.view as! ChangePasswordView).oldPasswordInput {
            (self.view as! ChangePasswordView).oldPasswordInput.resignFirstResponder()
            (self.view as! ChangePasswordView).newPasswordInput.becomeFirstResponder()
        }
        if textField == (self.view as! ChangePasswordView).newPasswordInput {
            (self.view as! ChangePasswordView).newPasswordInput.resignFirstResponder()
            (self.view as! ChangePasswordView).repeatNewPasswordInput.becomeFirstResponder()
        }
        if textField == (self.view as! ChangePasswordView).repeatNewPasswordInput {
            (self.view as! ChangePasswordView).repeatNewPasswordInput.resignFirstResponder()
            (self.view as! ChangePasswordView).changePasswordButtonTapped(sender: (self.view as! ChangePasswordView).changePasswordButton)
        }
        return true
    }
    
}
