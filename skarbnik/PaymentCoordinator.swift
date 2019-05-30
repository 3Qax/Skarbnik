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
    
    
    
    
    
    
    init(ofStudentWithID: Int, andName name: String, inClassWithID: Int, navigationController: UINavigationController) {
        self.studentID = ofStudentWithID
        self.studentName = name
        self.classID = inClassWithID
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
    
    func showImages(_ images: [Payment.Image]) {
        let imagesVC = ImagesViewController(of: images)
        imagesVC.coordinator = self
        navigationController.pushViewController(imagesVC, animated: true)
    }
    
    func showContribution(of payment: Payment) {
        let contributionVC = ContributionsViewController(of: payment)
        contributionVC.coordinator = self
        navigationController.pushViewController(contributionVC, animated: true)
    }
    
    
}

extension PaymentCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("From: \(fromVC), to \(toVC)")
        if fromVC is PaymentViewController && toVC is DetailsViewController
            || (fromVC is DetailsViewController && toVC is PaymentViewController) {
            return SlideInAnimationController()
        } else if fromVC is DetailsViewController && toVC is ImagesViewController
            || (fromVC is ImagesViewController && toVC is DetailsViewController)  {
            return SlideInAnimationController()
        } else { return nil }
    }
}
