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
    let eventStore      = EKEventStore()
    var coordinator: MainCoordinator?
    
    
    
    init(of studentID: Int, in classID: Int) {
        paymentModel = PaymentModel(of: studentID, in: classID)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PaymentView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePendingPaymentsSection(notification:)), name: .modelChangedPendingPayemnts, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePaidPaymentsSection), name: .modelChangedPaidPayemnts, object: nil)
        
        selectionFeedbackGenerator.prepare()
        
        
        (self.view as! PaymentView).delegate = self
        (self.view as! PaymentView).tableView.dataSource = self
        (self.view as! PaymentView).tableView.delegate = self
    }
    
    @objc func updatePendingPaymentsSection(notification: Notification) {
        DispatchQueue.main.sync {
            (self.view as! PaymentView).tableView.beginUpdates()
            (self.view as! PaymentView).tableView.insertRows(at: [IndexPath(row: (self.view as! PaymentView).tableView.numberOfRows(inSection: 0), section: 0)], with: .right)
            (self.view as! PaymentView).tableView.endUpdates()
        }
    }
    @objc func updatePaidPaymentsSection() {
        DispatchQueue.main.sync {
            (self.view as! PaymentView).tableView.beginUpdates()
            (self.view as! PaymentView).tableView.insertRows(at: [IndexPath(row: (self.view as! PaymentView).tableView.numberOfRows(inSection: 1), section: 1)], with: .right)
            (self.view as! PaymentView).tableView.endUpdates()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coordinator?.asyncSafetyController?.shouldShow = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: .modelChangedPendingPayemnts, object: nil)
        NotificationCenter.default.removeObserver(self, name: .modelChangedPaidPayemnts, object: nil)
        
        (self.view as! PaymentView).tableView.beginUpdates()
        
        for i in 0..<(self.view as! PaymentView).tableView.numberOfRows(inSection: 0) {
            (self.view as! PaymentView).tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .right)
        }
        
        for i in 0..<(self.view as! PaymentView).tableView.numberOfRows(inSection: 1) {
            (self.view as! PaymentView).tableView.deleteRows(at: [IndexPath(row: i, section: 1)], with: .right)
        }
        
        paymentModel.paidPayments.removeAll()
        paymentModel.pendingPayments.removeAll()
        (self.view as! PaymentView).tableView.endUpdates()
    }
    
}

extension PaymentViewController: PaymentViewProtocol {
    
    //provide student changing functionality
    func didTappedClass() {
        selectionFeedbackGenerator.prepare()
        coordinator?.navigationController.popViewController(animated: true)
        coordinator?.didRequestStudentChange()
    }
    
    func didRequestDataRefresh(completion: @escaping () -> ()) {
        (self.view as! PaymentView).tableView.beginUpdates()
        
        for i in 0..<(self.view as! PaymentView).tableView.numberOfRows(inSection: 0) {
            (self.view as! PaymentView).tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .right)
        }
        
        for i in 0..<(self.view as! PaymentView).tableView.numberOfRows(inSection: 1) {
            (self.view as! PaymentView).tableView.deleteRows(at: [IndexPath(row: i, section: 1)], with: .right)
        }
        
        paymentModel.refreshData(deletedDataHandler: {
            (self.view as! PaymentView).tableView.endUpdates()
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
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PendingCell") as! PendingPaymentCellView
            cell.setup(paymentModel.pendingPayments[indexPath.row]!.name, paymentModel.pendingPayments[indexPath.row]!.description, paymentModel.pendingPayments[indexPath.row]!.amount)
            cell.delegate = self
            cell.key = indexPath.row
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaidCell") as! PaidPaymentCellView
            cell.setup(paymentModel.paidPayments[indexPath.row]!.name, paymentModel.paidPayments[indexPath.row]!.description, paymentModel.paidPayments[indexPath.row]!.amount)

            cell.delegate = self
            cell.tableView = (self.view as! PaymentView).tableView
            return cell
        default:
            fatalError("TableView was ask for cell for unexpected section with number: \(indexPath.section)")
        }
    }
    
}

extension PaymentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let title = UILabel()
        
        switch section {
            case 0:
                title.text = NSLocalizedString("pending_payments_section_header", comment: "")
            case 1:
                 title.text = NSLocalizedString("paid_payments_section_header", comment: "")
            default:
                fatalError("Unknow section in tableView")
        }
        title.textColor = UIColor(rgb: 0x00A1E6)
        title.font = UIFont(name: "PingFangTC-Regular", size: 20.0)
        
        headerView.backgroundColor = UIColor(rgb: 0xF5F5F5)
        headerView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5)
        }
        
        return headerView
    }
    
}
