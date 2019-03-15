//
//  PayViewController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 13/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit


class PayViewController: UIViewController {
    
    let payView: PayView
    let payModel: PayModel
    var coordinator: MainCoordinator?
    
    
    
    override func loadView() {
        view = payView
    }
    
    init(for name: String, total: Float, remittances: [Float], currencyFormatter: NumberFormatter) {
        payView = PayView(totalAmount: total,
                          amountToPay: total - remittances.reduce(0, +),
                          remittances: remittances,
                          amountFormatter: currencyFormatter)
        payModel = PayModel(of: name, remittances: remittances)
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = payModel.paymentName
        navigationItem.largeTitleDisplayMode = .never
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        payView.refresh()
    }
}
