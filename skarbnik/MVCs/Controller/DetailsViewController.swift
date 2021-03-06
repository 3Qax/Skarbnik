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
        amountFormatter.locale = payment.amountLocale
        amountFormatter.numberStyle = .currency
        
        switch payment.state {
            
        case .awaiting:
            detailsToShow.append(Detail(title: "utworzona przez", value: "Anna Król"))
            detailsToShow.append(Detail(title: "rozpoczynie się", value: dateFormatter.string(from: payment.startDate)))
            detailsToShow.append(Detail(title: "zakończy się", value: dateFormatter.string(from: payment.endDate)))
        case .pending:
            detailsToShow.append(Detail(title: "utworzona przez", value: "Anna Król"))
            detailsToShow.append(Detail(title: "rozpoczeła się", value: dateFormatter.string(from: payment.startDate)))
            detailsToShow.append(Detail(title: "zakończy się", value: dateFormatter.string(from: payment.endDate)))
            detailsToShow.append(Detail(title: "do zapłaty", value: amountFormatter.string(from: payment.leftToPay as NSNumber)!))
            if payment.contributions.map({ $0.amount }).reduce(0, +) != 0.0 { detailsToShow.append(Detail(title: "wpłacono", value: amountFormatter.string(from: payment.contributions.map({ $0.amount }).reduce(0, +) as NSNumber)!)) }
        case .paid:
            detailsToShow.append(Detail(title: "utworzona przez", value: "Anna Król"))
            detailsToShow.append(Detail(title: "zapłacone", value: amountFormatter.string(from: payment.amount as NSNumber)!))
        }
        detailsView = DetailsView(showing: detailsToShow,
                                  ofPaymentNamed: payment.title,
                                  withDescription: payment.description,
                                  inState: payment.state,
                                  havingPhotos: payment.images.count != 0)
        detailsModel = DetailsModel(of: payment)
        
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
    
    func didTapImages() {
        if detailsModel.payment.images.count != 0 {
            coordinator?.showImages(detailsModel.payment.images)
        } else {
            notificationFeedbackGenerator.notificationOccurred(.error)
            
            AlertBuilder()
                .setMessage("Ta zbiórka nie ma dodanych żadnych zdjęć, więc nie możemy ich wyświetlić 🧐")
                .addAction(withStyle: .default, text: "OK")
                .show(in: self)
        }
    }
    
    func didTapList() {
        coordinator?.showContribution(of: detailsModel.payment)
    }
    
    func didTapWallet() {
        coordinator?.didRequestToPay(for: detailsModel.payment)
    }
    
    func didTapBell() {
        coordinator?.didRequestReminder(about: detailsModel.payment)
    }
    
    func didTapBack() {
        coordinator?.goBack()
    }
    
}
