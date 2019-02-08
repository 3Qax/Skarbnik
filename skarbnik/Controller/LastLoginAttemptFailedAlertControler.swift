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
    let lastLoginUnsuccessfulAlert: UIAlertController
    var coordinator: MainCoordinator?
    
    
    init(when date: String, from ip: String) {
        self.lastLoginUnsuccessfulAlert = UIAlertController(title: NSLocalizedString("last_login_failed_header", comment: ""),
                                                            message: NSLocalizedString("last_login_failed_description_before", comment: "")
                                                                + date.description
                                                                + NSLocalizedString("last_login_failed_description_from", comment: "")
                                                                + ip
                                                                + NSLocalizedString("last_login_failed_description_end", comment: ""),
                                                            preferredStyle: .alert)
        super.init(nibName: nil, bundle: nil)
        self.lastLoginUnsuccessfulAlert.addAction(UIAlertAction(title: NSLocalizedString("last_login_failed_change_password_button_text", comment: ""), style: .default, handler: { _ in
            self.dismiss(animated: true)
            self.coordinator?.didRequestPasswordChange()
        }))
        self.lastLoginUnsuccessfulAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            self.dismiss(animated: true)
        }))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        notificationFeedbackGenerator.notificationOccurred(.warning)
        self.present(lastLoginUnsuccessfulAlert, animated: true)
    }
    
    
    
}
