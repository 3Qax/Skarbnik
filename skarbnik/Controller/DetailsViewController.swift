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
        
        switch payment.state {
            
        case .awaiting:
            detailsToShow.append(Detail(title: "coś się", value: "nie udało"))
        case .pending:
            detailsToShow.append(Detail(title: "utworzona przez", value: "Anna Król"))//["utworzona przez"] = "Anne Król"
            detailsToShow.append(Detail(title: "rozpoczyna się", value: "25 maj 2019r."))//[""] = ""
            detailsToShow.append(Detail(title: "zakończy się", value: "14 czerwca 2019r."))//["zakończy się"] = ""
            detailsToShow.append(Detail(title: "do zapłaty", value: "504,90zł"))//[""] = ""
        case .paid:
            detailsToShow.append(Detail(title: "zapłacone", value: "bardzo"))//["utworzona przez"] = ""
            //detailsToShow.append(Detail(title: "", value: ""))//[""] = ""
            //detailsToShow.append(Detail(title: "", value: ""))//[""] = ""
            //detailsToShow.append(Detail(title: "", value: ""))//[""] = ""
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
    
}

extension DetailsViewController: DetailsViewDelegate {
    func didTapBack() {
        coordinator?.goBack()
    }
    
}

extension DetailsViewController: Slidable {
    func slideIn() {
        detailsView.slideIn()
    }
    
    func slideOut() {
        
    }
    
    
}
