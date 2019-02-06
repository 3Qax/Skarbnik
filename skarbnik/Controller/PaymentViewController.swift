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
        
        //don't allow user to change student while loading one
//        (self.view as! PaymentView).headerChangeStudentImageView.isUserInteractionEnabled = false
//        (self.view as! PaymentView).headerChangeStudentImageView.alpha = 0.3
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePendingPaymentsSection), name: .modelChangedPendingPayemnts, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePaidPaymentsSection), name: .modelChangedPaidPayemnts, object: nil)
        
        selectionFeedbackGenerator.prepare()
        
        
        (self.view as! PaymentView).delegate = self
        (self.view as! PaymentView).tableView.dataSource = self
        (self.view as! PaymentView).tableView.delegate = self
    }
    
    @objc func updatePendingPaymentsSection() {
        DispatchQueue.main.async {
            (self.view as! PaymentView).tableView.reloadSections(IndexSet(integer: 0), with: .right)
        }
    }
    @objc func updatePaidPaymentsSection() {
        DispatchQueue.main.async {
            (self.view as! PaymentView).tableView.reloadSections(IndexSet(integer: 1), with: .right)
        }
    }
    
}

extension PaymentViewController: PaymentViewProtocol {
    
    //provide student changing functionality
    func didTappedClass() {
        selectionFeedbackGenerator.prepare()
        coordinator?.didLoginSuccessfully()
    }
    
    func didRequestDataRefresh(completion: () -> ()) {
        paymentModel.refreshData()
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
            let dataKey = paymentModel.pendingPayments.index(paymentModel.pendingPayments.startIndex, offsetBy: indexPath.row)
            cell.setup(paymentModel.pendingPayments[dataKey].value.name, paymentModel.pendingPayments[dataKey].value.description, paymentModel.pendingPayments[dataKey].value.amount)
            cell.delegate = self
            cell.key = paymentModel.pendingPayments[dataKey].key
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaidCell") as! PaidPaymentCellView
            let dataKey = paymentModel.paidPayments.index(paymentModel.paidPayments.startIndex, offsetBy: indexPath.row)
            cell.setup(paymentModel.paidPayments[dataKey].value.name, paymentModel.paidPayments[dataKey].value.description, paymentModel.paidPayments[dataKey].value.amount)
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
