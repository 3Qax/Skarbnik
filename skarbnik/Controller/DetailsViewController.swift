//
//  DetailsViewController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 14/04/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class DetailsViewController: UIViewController {
    let detailsView: DetailsView
    let detailsModel: DetailsModel
    var coordinator: PaymentCoordinator?
    
    
    
    init(of payment: Payment) {
        
        
        var detailsToShow: [Detail] = [Detail]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        
        let amountFormatter = NumberFormatter()
        amountFormatter.locale = Locale.availableIdentifiers.lazy.map({Locale(identifier: $0)}).first(where: { $0.currencyCode == payment.currency })
        amountFormatter.numberStyle = .currency
        
        switch payment.state {
            
        case .awaiting:
            detailsToShow.append(Detail(title: "utworzona przez", value: "Anna Król"))
            detailsToShow.append(Detail(title: "rozpoczynie się", value: dateFormatter.string(from: payment.start_date)))
            detailsToShow.append(Detail(title: "zakończy się", value: dateFormatter.string(from: payment.end_date)))
        case .pending:
            detailsToShow.append(Detail(title: "utworzona przez", value: "Anna Król"))
            detailsToShow.append(Detail(title: "rozpoczeła się", value: dateFormatter.string(from: payment.start_date)))
            detailsToShow.append(Detail(title: "zakończy się", value: dateFormatter.string(from: payment.end_date)))
            detailsToShow.append(Detail(title: "do zapłaty", value: amountFormatter.string(from: payment.leftToPay as NSNumber)!))
            if payment.contribution.reduce(0, +) != 0.0 { detailsToShow.append(Detail(title: "wpłacono", value: amountFormatter.string(from: payment.contribution.reduce(0, +) as NSNumber)!)) }
        case .paid:
            detailsToShow.append(Detail(title: "utworzona przez", value: "Anna Król"))
            detailsToShow.append(Detail(title: "zapłacone", value: amountFormatter.string(from: payment.amount as NSNumber)!))
        }
        detailsView = DetailsView(showing: detailsToShow, ofPaymentNamed: payment.name, withDescription: payment.description)
        detailsModel = DetailsModel()
        
        super.init(nibName: nil, bundle: nil)
        
        detailsView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
    }
    
    override func loadView() {
        view = detailsView
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detailsView.setNeedsLayout()
        detailsView.layoutIfNeeded()
    }
    
}

extension DetailsViewController: DetailsViewDelegate {
    func didTapBack() {
        coordinator?.goBack()
    }
    
}
