//
//  ChangePasswordController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 06/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit


class AsyncSafetyController {
    var safetyModel = AsyncSafetyModel()
    weak var coordinator: LoginCoordinator?
    

    
    init() {
        safetyModel.delegate = self
        safetyModel.start()
    }
    
}

extension AsyncSafetyController: AsyncSafetyProtocool {
        
    func requirePasswordChange() {
        self.coordinator?.shouldChangePassword()
    }
    
    func lastLoginUnsuccessful(_ date: Date, fromIP ip: String) {
        print("last login unsuccessful")
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        let formattedDate = formatter.string(from: date)
        
        self.coordinator?.shouldWarnAboutLastLogin(on: formattedDate, from: ip)
    }
    
    func everythingOk() {
        print("everything OK")
        self.coordinator?.safetyCheckEnded()
        
    }
    
}
