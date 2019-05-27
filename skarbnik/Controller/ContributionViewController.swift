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
    
    
    init(list: [Contribution]) {
        self.contributionView = ContributionView()
        self.list = list
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contributionView
    }
    
}
