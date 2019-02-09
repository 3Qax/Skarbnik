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
    private let model = AsyncSafetyModel()
    weak var coordinator: MainCoordinator?
    
    private var lastLoginWasUnsuccessful: Bool?
    private var dateOfUnsuccessfulLogin: String?
    private var ipOfUnsuccessfulLogin: String?
    private var doRequirePasswordChange: Bool?
    
    var shouldShow: Bool = false {
        didSet {
            if shouldShow, let doRequirePasswordChange = doRequirePasswordChange, let lastLoginWasUnsuccessful = lastLoginWasUnsuccessful {
                if doRequirePasswordChange {
                    DispatchQueue.main.async {
                        self.coordinator?.shouldChangePassword()
                    }
                }
                if lastLoginWasUnsuccessful {
                    DispatchQueue.main.async {
                        self.coordinator?.shouldWarnAboutLastLogin(on: self.dateOfUnsuccessfulLogin ?? "", from: self.ipOfUnsuccessfulLogin ?? "")
                    }
                }
                coordinator?.asyncSafetyController = nil
            }
        }
    }

    
    init() {
        model.delegate = self
    }
    
    deinit {
        print("AsyncSafetyController dealocated!")
    }
}

extension AsyncSafetyController: AsyncSafetyProtocool {
    
    func dontRequirePasswordChange() {
        doRequirePasswordChange = false
    }
    
    func lastLoginSuccessful() {
        lastLoginWasUnsuccessful = false
    }
    
    func requirePasswordChange() {
        print("require password change")
        doRequirePasswordChange = true
    }
    
    func lastLoginUnsuccessful(_ date: Date, fromIP ip: String) {
        print("last login unsuccessful")
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        dateOfUnsuccessfulLogin = formatter.string(from: date)
        ipOfUnsuccessfulLogin = ip
        lastLoginWasUnsuccessful = true
    }
    
}
