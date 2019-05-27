//
//  ContributionViewController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 25/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class ContributionViewController: UIViewController {
    let contributionView: ContributionView
    let list: [Contribution]
    
    var coordinator: PaymentCoordinator?
    
    
    init(list: [Contribution], in currencyCode: String) {
        self.contributionView = ContributionView(paymentCurrencyCode: currencyCode)
        self.list = list
        super.init(nibName: nil, bundle: nil)
        
        contributionView.insertCreation(date: Date())
        contributionView.insertContribution(amount: 250.0, date: Date())
        contributionView.insertContribution(amount: 400.20, date: Date(), isFinal: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contributionView
    }
    
}

extension ContributionViewController: ContributionViewDelegate {
    
    func didTapBack() {
        coordinator?.goBack()
    }
    
}
