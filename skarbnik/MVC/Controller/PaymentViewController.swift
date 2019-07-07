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
        paymentView.tableView.setContentOffset(CGPoint(x: 0, y: -50), animated: false)
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
        cell.setupContent(title: payment.title,
                          description: payment.description,
                          amount: payment.leftToPay == 0.0 ? payment.amount : payment.leftToPay,
                          currency: payment.amountLocale.currencyCode!.localizedUppercase,
                          startDate: payment.startDate)
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
    
    func didTapCellsForeground(sender: PaymentCellView) {
        if let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item {
            coordinator?.showDetails(of: paymentModel.payments[index])
        }
    }
    
    func didTriggerLeftAction(sender: PaymentCellView) {
        if let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item {
            switch paymentModel.payments[index].state {
            case .awaiting:
                fatalError("Left swipe action for awaiting payments has not been implemented yet.")
            case .pending:
                coordinator?.didRequestReminder(about: paymentModel.payments[index])
            case .paid:
                //check if payment has images
                if paymentModel.payments[index].images.count != 0 {
                    coordinator?.showImages(paymentModel.payments[index].images)
                } else {
                    AlertBuilder()
                        .setMessage("Ta zbiórka nie ma dodanych żadnych zdjęć, więc nie możemy ich wyświetlić 🧐")
                        .addAction(withStyle: .default, text: "OK")
                        .show(in: self)
                    notificationFeedbackGenerator.notificationOccurred(.error)
                }
            }
        }
    }
    
    func didTriggerRightAction(sender: PaymentCellView) {
        if let index = paymentView.tableView.indexPath(for: sender as UITableViewCell)?.item {
            switch paymentModel.payments[index].state {
            case .awaiting:
                fatalError("Right swipe action for awaiting payments has not been implemented yet.")
            case .pending:
                coordinator?.didRequestToPay(for: paymentModel.payments[index])
            case .paid:
                coordinator?.showContribution(of: paymentModel.payments[index])
            }
        }
    }

    
    
}
