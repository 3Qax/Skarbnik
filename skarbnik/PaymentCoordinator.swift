//
//  PaymentCoordinator.swift
//  skarbnik
//
//  Created by Jakub Towarek on 18/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class PaymentCoordinator: Coordinator {
    
    weak var parentCoordinator: MainCoordinator?
    
    var children: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    let studentID, classID: Int
    var paymentVC: PaymentViewController?
    
    
    
    
    
    init(ofStudentWithID: Int, inClassWithID: Int, navigationController: UINavigationController) {
        self.studentID = ofStudentWithID
        self.classID = inClassWithID
        self.navigationController = navigationController
    }
    
    func start() {
        paymentVC = PaymentViewController(of: studentID, in: classID)
        paymentVC!.coordinator = self
    }
    
    //
    //---------------------------------------------------------------------------------------
    //
    
    func readyToPresentPayments() {
        navigationController.pushViewController(paymentVC!, animated: true)
    }
    
    func didRequestReminder(about payment: Payment) {
        let reminderController = ReminderViewController(about: payment)
        reminderController.coordinator = self
        navigationController.pushViewController(reminderController, animated: true)
    }
    
    func didAddReminder() {
        navigationController.popViewController(animated: true)
    }
    
    func didCancelAddingReminder() {
        navigationController.popViewController(animated: true)
    }
    
    func didRequestToPay(for payment: Payment, withCurrencyFormatter formatter: NumberFormatter) {
        let payViewController = PayViewController(for: payment, currencyFormatter: formatter)
        payViewController.coordinator = self
        navigationController.pushViewController(payViewController, animated: true)
        
    }
    
    func didRequestStudentChange() {
        parentCoordinator?.childDidFinish(self)
        parentCoordinator?.didRequestStudentChange()
    }
    
    
}
