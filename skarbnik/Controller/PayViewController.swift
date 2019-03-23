//
//  PayViewController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 13/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit
import PassKit


class PayViewController: UIViewController {
    let payView: PayView
    let payModel: PayModel
    var coordinator: PaymentCoordinator?
    
    
    
    override func loadView() {
        payView.delegate = self
        view = payView
    }
    
    init(for payment: Payment, currencyFormatter: NumberFormatter) {
        payModel = PayModel(of: payment)
        payView = PayView(totalAmount: payment.amount,
                          amountToPay: payment.amount - payment.contribution.reduce(0, +),
                          remittances: payment.contribution,
                          amountFormatter: currencyFormatter)
        
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = payModel.payment.name
        navigationItem.largeTitleDisplayMode = .never
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
}

extension PayViewController: PayViewDelegate {
    func didTapBack() {
        coordinator?.goBack()
    }
    
    func didTapPay() {
        payModel.pay(Float(payView.slider.value))
    }
    
    func didTapPayOnWeb() {
        guard let url = URL(string: "https://github.com/FilipJedrasik/hackathon-skarbnik") else { return }
        UIApplication.shared.open(url)
    }
}

extension PayViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === navigationController?.interactivePopGestureRecognizer else { return true }
        let doesContain = payView.slider.frame.contains(gestureRecognizer.location(in: payView))
        return !doesContain //if touch occured within slider frame interrupt it
    }
}
