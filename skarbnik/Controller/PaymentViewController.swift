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
            print("got asked for number of rows in section \(section), returned \(paymentModel.pendingPayments.filter({p in paymentModel.filter(p.value)}).count)")
            return paymentModel.pendingPayments.filter({p in paymentModel.filter(p.value)}).count
        case 1:
            print("got asked for number of rows in section \(section), returned \(paymentModel.paidPayments.filter({p in paymentModel.filter(p.value)}).count)")
            return paymentModel.paidPayments.filter({p in paymentModel.filter(p.value)}).count
        default:
            fatalError("Asked for number of rows in \(section) section, while there are only 2 sections possible (0 and 1).")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCellView") as! PaymentCellView
        cell.delegate = self
        print("Cell for section \(indexPath.section), row: \(indexPath.row)")
        switch indexPath.section {
        case 0:
            cell.style = .pending
            cell.setupContent(title: Array(paymentModel.pendingPayments.filter({p in paymentModel.filter(p.value)}))[indexPath.row].value.name,
                              description: Array(paymentModel.pendingPayments.filter({p in paymentModel.filter(p.value)}))[indexPath.row].value.description,
                              amount: Array(paymentModel.pendingPayments.filter({p in paymentModel.filter(p.value)}))[indexPath.row].value.amount,
                              currency: Array(paymentModel.pendingPayments.filter({p in paymentModel.filter(p.value)}))[indexPath.row].value.currency)
        case 1:
            cell.style = .paid
            cell.setupContent(title: Array(paymentModel.paidPayments.filter({p in paymentModel.filter(p.value)}))[indexPath.row].value.name,
                       description: Array(paymentModel.paidPayments.filter({p in paymentModel.filter(p.value)}))[indexPath.row].value.description,
                       amount: Array(paymentModel.paidPayments.filter({p in paymentModel.filter(p.value)}))[indexPath.row].value.amount,
                       currency: Array(paymentModel.paidPayments.filter({p in paymentModel.filter(p.value)}))[indexPath.row].value.currency)
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
        coordinator?.didRequestReminder(about: Array(paymentModel.pendingPayments.filter({p in paymentModel.filter(p.value)}))[index].value.name,
                                        ending: Array(paymentModel.pendingPayments.filter({p in paymentModel.filter(p.value)}))[index].value.end_date)
    }
    
    func didTapPayButton(sender: PaymentCellView) {
        guard let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item else {
            fatalError("TableView didn't return indexPath")
        }
        coordinator?.didRequestToPay(for: Array(paymentModel.pendingPayments.filter({p in paymentModel.filter(p.value)}))[index].value.name,
                                     total: Array(paymentModel.pendingPayments.filter({p in paymentModel.filter(p.value)}))[index].value.amount,
                                     remittances: Array(paymentModel.pendingPayments.filter({p in paymentModel.filter(p.value)}))[index].value.contribution,
                                     currencyFormatter: sender.amountFormatter)
    }
    
    func didTapMoreButton(sender: PaymentCellView) {
        print("tapped more")
    }
}

extension PaymentViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        paymentModel.setFilter(containing: searchText)
        paymentView.tableView.reloadData()
    }
}
