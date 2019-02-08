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
    let model = AsyncSafetyModel()
    var coordinator: MainCoordinator?
    
    init() {
        model.delegate = self
    }
}

extension AsyncSafetyController: AsyncSafetyProtocool {
    func requirePasswordChange() {
        DispatchQueue.main.async {
            self.coordinator?.shouldChangePassword()
        }
    }
    
    func lastLoginUnsuccessful(_ date: Date, fromIP ip: String) {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        DispatchQueue.main.async {
            self.coordinator?.shouldWarnAboutLastLogin(on: formatter.string(from: date), from: ip)
        }
    }
    
}
