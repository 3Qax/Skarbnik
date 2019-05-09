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
    
    
    
    init(of name: String, studentID: Int, in classID: Int) {
        paymentModel = PaymentModel(of: studentID, in: classID)
        paymentView = PaymentView(firstName: name.components(separatedBy: " ").dropLast().reduce("", { $0=="" ? $1 : $0 + " " + $1 }),
                                  lastName: name.components(separatedBy: " ").last ?? "")
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        paymentView.updateStats(pending: paymentModel.payments.filter({ $0.state == .pending }).count,
                                paid: paymentModel.payments.filter({ $0.state == .paid }).count)
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
    
    func shouldCancelSearch(in searchBar: SearchField) {
        paymentModel.setFilter(to: "")
        searchBar.text = ""
        paymentView.tableView.reloadData()
    }
    
    func searchTermDidChanged(term: String) {
        paymentModel.setFilter(to: term)
        paymentView.tableView.reloadData()
    }
    
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
                          amount: payment.leftToPay == 0.0 ? payment.amount : payment.leftToPay,
                          currency: payment.currency,
                          startDate: payment.start_date)
        tableView.beginUpdates()
        switch payment.state {
        case .pending:
            cell.style = .pending
        case .awaiting:
            cell.style = .paid
        case .paid:
            cell.style = .paid
        }
        
        cell.layoutSubviews()
        tableView.endUpdates()
        
        cell.layer.addShadow(Xoffset: 0, Yoffset: 4, blurRadius: 2)
        
        return cell
        
    }
    
}

extension PaymentViewController: PaymentCellDelegate {
    func didTapCell(sender: PaymentCellView) {
        if let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item {
            print("Tapped cell at index: \(index)")
            coordinator?.showDetails(of: paymentModel.payments[index])
        }
    }
    
    func didTapRemind(sender: PaymentCellView) {
        
        if let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item {
            coordinator?.didRequestReminder(about: paymentModel.payments[index])
        }
        
    }
    
    func didTapPay(sender: PaymentCellView) {
        
        if let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item {
            coordinator?.didRequestToPay(for: paymentModel.payments[index])
        }
        
    }
    
}
