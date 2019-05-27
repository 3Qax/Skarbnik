//
//  CompulsoryPasswordChangeAlertController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 09/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit


class CompulsoryPasswordChangeAlertController: UIViewController {
    let compulsoryPasswordChangeAlert: AlertBuilder
    var coordinator: LoginCoordinator?
    
    
    init() {
        self.compulsoryPasswordChangeAlert = AlertBuilder()
                                                .basicAlert(withTitle: NSLocalizedString("compulsory_password_change_title", comment: ""))
                                                .setMessage(NSLocalizedString("compulsory_password_change_description", comment: ""))
        
        super.init(nibName: nil, bundle: nil)
        
        self.compulsoryPasswordChangeAlert.addAction(withStyle: .default, text: NSLocalizedString("compulsory_password_change_button_text", comment: ""), handler: { _ in
            self.coordinator?.navigationController.dismiss(animated: true)
            self.coordinator?.didRequestPasswordChange()
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
        self.compulsoryPasswordChangeAlert.show(in: self, animated: true)
    }
}
