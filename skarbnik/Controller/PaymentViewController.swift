//
//  PaymentView.swift
//  skarbinik
//
//  Created by Jakub Towarek on 24/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit
import EventKit

class PaymentViewController: UIViewController {
    let paymentModel: PaymentModel
    let paymentView: PaymentView
    var coordinator: PaymentCoordinator?
    private var isShown: Bool = false
    
    
    
    init(of studentID: Int, in classID: Int) {
        paymentModel = PaymentModel(of: studentID, in: classID)
        paymentView = PaymentView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadedData), name: .modelLoadedPayments, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = paymentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionFeedbackGenerator.prepare()
        
        
       
        
        
        paymentView.delegate = self
        paymentView.tableView.dataSource = self
        paymentView.searchBar.delegate = self
    }
    
    @objc func loadedData() {
        self.paymentView.reloadData()
        
        if !isShown {
            self.coordinator!.readyToPresentPayments()
            isShown = true
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .modelLoadedPayments, object: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension PaymentViewController: PaymentViewDelegate {
    
    func didTappedClass() {
        selectionFeedbackGenerator.prepare()
        coordinator?.navigationController.popViewController(animated: true)
        coordinator?.didRequestStudentChange()
    }
    
    func didRequestDataRefresh() {
        paymentModel.refreshData()
    }
}

extension PaymentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return paymentModel.payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCellView") as! PaymentCellView
        cell.delegate = self
        
        let payment = paymentModel.payments[indexPath.row]
        cell.setupContent(title: payment.name,
                          description: payment.description,
                          amount: payment.leftToPay,
                          currency: payment.currency,
                          startDate: payment.start_date)
        tableView.beginUpdates()
        switch payment.state {
        case .pending:
            cell.style = .pending
        case .awaiting:
            cell.style = .awaiting
        case .paid:
            cell.style = .paid
        }
        
        cell.layoutSubviews()
        tableView.endUpdates()
        return cell
        
    }
    
}

extension PaymentViewController: PaymentCellDelegate {
    func didTapCell(sender: PaymentCellView) {
        if let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item {
            print("Tapped cell at index: \(index)")
        }
    }
    
    func didTapRemindButton(sender: PaymentCellView) {
        
        if let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item {
            coordinator?.didRequestReminder(about: paymentModel.payments[index])
        }
        
    }
    
    func didTapPayButton(sender: PaymentCellView) {
        
        if let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item {
            coordinator?.didRequestToPay(for: paymentModel.payments[index], withCurrencyFormatter: sender.amountFormatter)
        }
        
    }
    
    func didTapMoreButton(sender: PaymentCellView) {
        

    }
}

extension PaymentViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        paymentModel.setFilter(to: searchText)
        paymentView.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        paymentModel.setFilter(to: "")
        paymentView.tableView.reloadData()
    }
}
