//
//  LastLoginAttemptFailedAlertControler.swift
//  skarbnik
//
//  Created by Jakub Towarek on 07/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit



class LastLoginAttemptFailedAlertControler: UIViewController {
    let lastLoginUnsuccessfulAlert: AlertBuilder
    var coordinator: LoginCoordinator?
    
    
    init(when date: String, from ip: String) {

        let alertMessage = NSLocalizedString("last_login_failed_description_before", comment: "")
                            + date.description
                            + NSLocalizedString("last_login_failed_description_from", comment: "")
                            + ip
                            + NSLocalizedString("last_login_failed_description_end", comment: "")
        self.lastLoginUnsuccessfulAlert = AlertBuilder()
            .basicAlert(withTitle: NSLocalizedString("last_login_failed_header", comment: ""))
            .setMessage(alertMessage)
        
        
        super.init(nibName: nil, bundle: nil)
        
        self.lastLoginUnsuccessfulAlert.addAction(withStyle: .default, text: NSLocalizedString("last_login_failed_change_password_button_text", comment: ""), handler: { _ in
            self.coordinator?.didRequestPasswordChange()
            self.coordinator?.navigationController.dismiss(animated: true)
        })
        self.lastLoginUnsuccessfulAlert.addAction(withStyle: .destructive, text: "OK", handler: { _ in
            self.coordinator?.navigationController.dismiss(animated: true)
            self.coordinator?.safetyCheckEnded()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        notificationFeedbackGenerator.notificationOccurred(.warning)
        lastLoginUnsuccessfulAlert.show(in: self, animated: true)
    }
    
    
    
}
