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
        navigationController?.navigationBar.prefersLargeTitles = true
        
        paymentView.delegate = self
        paymentView.tableView.dataSource = self
    }
    
    @objc func updatePendingPaymentsSection(notification: Notification) {
        DispatchQueue.main.sync {
            paymentView.tableView.beginUpdates()
            paymentView.tableView.insertRows(at: [IndexPath(row: paymentView.tableView.numberOfRows(inSection: 0), section: 0)], with: .right)
            paymentView.tableView.endUpdates()
        }
    }
    @objc func updatePaidPaymentsSection() {
        DispatchQueue.main.sync {
            paymentView.tableView.beginUpdates()
            paymentView.tableView.insertRows(at: [IndexPath(row: paymentView.tableView.numberOfRows(inSection: 1), section: 1)], with: .right)
            paymentView.tableView.endUpdates()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(updatePendingPaymentsSection(notification:)), name: .modelChangedPendingPayemnts, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePaidPaymentsSection), name: .modelChangedPaidPayemnts, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coordinator?.asyncSafetyController?.shouldShow = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .modelChangedPendingPayemnts, object: nil)
        NotificationCenter.default.removeObserver(self, name: .modelChangedPaidPayemnts, object: nil)
    }
    
}

extension PaymentViewController: PaymentViewDelegate {
    
    //provide student changing functionality
    func didTappedClass() {
        selectionFeedbackGenerator.prepare()
        coordinator?.navigationController.popViewController(animated: true)
        coordinator?.didRequestStudentChange()
    }
    
    func didRequestDataRefresh(completion: @escaping () -> ()) {
        paymentView.tableView.beginUpdates()
        
        for i in 0..<paymentView.tableView.numberOfRows(inSection: 0) {
            paymentView.tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .right)
        }
        
        for i in 0..<paymentView.tableView.numberOfRows(inSection: 1) {
            paymentView.tableView.deleteRows(at: [IndexPath(row: i, section: 1)], with: .right)
        }
        
        paymentModel.refreshData(deletedDataHandler: {
            paymentView.tableView.endUpdates()
        }, completion: {
            completion()
        })

    }
}

extension PaymentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return paymentModel.pendingPayments.count
        case 1:
            return paymentModel.paidPayments.count
        default:
            fatalError("Asked for number of rows in \(section) section, while there are only 2 sections possible (0 and 1).")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCellView") as! PaymentCellView
        cell.delegate = self
        
        switch indexPath.section {
        case 0:
            cell.style = .pending
            cell.setupContent(title: paymentModel.pendingPayments[indexPath.row]!.name,
                              description: paymentModel.pendingPayments[indexPath.row]!.description,
                              amount: paymentModel.pendingPayments[indexPath.row]!.amount,
                              currency: paymentModel.pendingPayments[indexPath.row]!.currency)
        case 1:
            cell.style = .paid
            cell.setupContent(title: paymentModel.paidPayments[indexPath.row]!.name,
                       description: paymentModel.paidPayments[indexPath.row]!.description,
                       amount: paymentModel.paidPayments[indexPath.row]!.amount,
                       currency: paymentModel.paidPayments[indexPath.row]!.currency)
        default:
            fatalError("TableView was ask for cell for unexpected section with number: \(indexPath.section)")
        }
        
        return cell
    }
    
}

extension PaymentViewController: PaymentCellDelegate {
    func didTapRemindButton(sender: PaymentCellView) {
        
        guard let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item else {
            fatalError("TableView didn't return indexPath")
        }
        coordinator?.didRequestReminder(about: paymentModel.pendingPayments[index]!.name,
                                        ending: paymentModel.pendingPayments[index]!.end_date)
    }
    
    func didTapPayButton(sender: PaymentCellView) {
        guard let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item else {
            fatalError("TableView didn't return indexPath")
        }
        coordinator?.didRequestToPay(for: paymentModel.pendingPayments[index]!.name,
                                     total: paymentModel.pendingPayments[index]!.amount,
                                     remittances: paymentModel.pendingPayments[index]!.contribution,
                                     currencyFormatter: sender.amountFormatter)
    }
    
    func didTapMoreButton(sender: PaymentCellView) {
        print("tapped more")
    }
}

extension PaymentViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
