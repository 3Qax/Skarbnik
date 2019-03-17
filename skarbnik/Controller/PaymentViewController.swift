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
    let searchController: UISearchController
    var coordinator: MainCoordinator?
    
    
    
    init(of studentID: Int, in classID: Int) {
        paymentModel = PaymentModel(of: studentID, in: classID)
        paymentView = PaymentView(frame: UIScreen.main.bounds)
        searchController = UISearchController(searchResultsController: nil)
        super.init(nibName: nil, bundle: nil)
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
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Składki"
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: paymentView.changeStudentIV)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        paymentView.delegate = self
        paymentView.tableView.dataSource = self
    }
    
    @objc func loadedData() {
        DispatchQueue.main.async {
            self.paymentView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(loadedData), name: .modelLoadedPayments, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coordinator?.asyncSafetyController?.shouldShow = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .modelLoadedPayments, object: nil)
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
        print("Cell for section \(indexPath.section), row: \(indexPath.row)")
        
        let payment = paymentModel.payments[indexPath.row]
        cell.setupContent(title: payment.name,
                          description: payment.description,
                          amount: payment.amount,
                          currency: payment.currency)
        
        switch payment.state {
        case .pending:
            cell.style = .pending
        case .partialyPaid:
            cell.style = .pending
        case .paid:
            cell.style = .paid
        }
        return cell
    }
    
}

extension PaymentViewController: PaymentCellDelegate {
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
        
        if let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item {
            print("Tapped more button of cell at index: \(index)")
        }
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
