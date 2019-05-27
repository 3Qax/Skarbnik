//
//  ContributionsViewController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 25/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class ContributionsViewController: UIViewController {
    let contributionsView: ContributionsView
    let payment: Payment
    
    var coordinator: PaymentCoordinator?
    
    
    init(of payment: Payment) {
        self.contributionsView = ContributionsView(paymentCurrencyCode: payment.currency)
        self.payment = payment
        super.init(nibName: nil, bundle: nil)
        
        //insert start day of the payment into the view
        contributionsView.insertCreation(date: payment.creation_date)
        //sort contributions so that they appear in right order (from top to bottom)
        payment.contributions.sort(by: { return $0.date > $1.date })
        //for each contribution except last one insert contribution view into the view
        payment.contributions.dropLast().forEach({ self.contributionsView.insertContribution(amount: $0.amount, date: $0.date) })
        //for last one insert a final contribution view into the view
        //it is safe to force unwrap since this view is only valid for paid payments (having status == .paid)
        contributionsView.insertContribution(amount: payment.contributions.last!.amount, date: payment.contributions.last!.date, isFinal: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contributionsView
        contributionsView.delegate = self
    }
    
}

extension ContributionsViewController: ContributionViewDelegate {
    
    func didTapBack() {
        coordinator?.goBack()
    }
    
}
