//
//  PaymentCoordinator.swift
//  skarbnik
//
//  Created by Jakub Towarek on 18/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class PaymentCoordinator: NSObject, Coordinator {
    
    weak var parentCoordinator: MainCoordinator?
    
    var children: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    let studentID, classID: Int
    let studentName: String
    var paymentVC: PaymentViewController?
    
    let animator: SlideInAnimationController
    
    
    
    
    
    init(ofStudentWithID: Int, andName name: String, inClassWithID: Int, navigationController: UINavigationController) {
        self.studentID = ofStudentWithID
        self.studentName = name
        self.classID = inClassWithID
        self.animator = SlideInAnimationController()
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
        
    }
    
    func start() {
        paymentVC = PaymentViewController(of: studentName, studentID: studentID, in: classID)
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
    
    func didRequestToPay(for payment: Payment) {
        let payViewController = PayViewController(for: payment)
        payViewController.coordinator = self
        navigationController.pushViewController(payViewController, animated: true)
        
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
    
    func didRequestStudentChange() {
        parentCoordinator?.childDidFinish(self)
        parentCoordinator?.didRequestStudentChange()
    }
    
    func showDetails(of payment: Payment) {
        let detailsVC = DetailsViewController(of: payment)
        detailsVC.coordinator = self
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    
}

extension PaymentCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is PaymentViewController && toVC is DetailsViewController {
            print("returned animator")
            return animator
        } else { return nil }
    }
}
