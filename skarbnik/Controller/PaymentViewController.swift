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
    var paymentModel: PaymentModel?
    let eventStore = EKEventStore()
    let studentPicker = UIAlertController(title: nil,
                                          message: NSLocalizedString("choose_student_description", comment: ""),
                                          preferredStyle: .actionSheet)
    
    
    
    override func loadView() {
        view = PaymentView(frame: UIScreen.main.bounds)
    }
    
    func didChoose(id: Int, completion: @escaping () -> ()) {
        let selectedChild = userModel!.children?.first(where: { (child) -> Bool in
            child.id_field == id
        })
        
        (self.view as! PaymentView).viewFor(child: selectedChild!)
        
        paymentModel = PaymentModel(for: selectedChild!, completion: {
            DispatchQueue.main.async {
                (self.view as! PaymentView).tableView.reloadData()
                completion()
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for child in userModel!.children! {
            studentPicker.addAction(UIAlertAction(title: "\(child.name)", style: .default, handler: { (_) in
                //TODO: show some amazing endless animation of loading
                self.didChoose(id: child.id_field, completion: {
                    //TODO: stop that amazing animation
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                        (self.view as! PaymentView).blurEffect.alpha = 0.0
                    })
                })
                self.studentPicker.dismiss(animated: true)
            }))
        }
        self.present(studentPicker, animated: true)
        
        (self.view as! PaymentView).tableView.dataSource = self
        (self.view as! PaymentView).delegate = self
    }
}

extension PaymentViewController: PaymentViewProtocol {
    //MARK: provide selectedChild changing functionality
    func didTappedClass() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            (self.view as! PaymentView).blurEffect.alpha = 1.0
        })
        self.present(studentPicker, animated: true)
    }
}

//MARK:
extension PaymentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("pending_payments_section_header", comment: "")
        }
        return NSLocalizedString("paid_payments_section_header", comment: "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let paymentModel = self.paymentModel {
            if section == 0 {
                return paymentModel.pendingPayments.count
            } else if section == 1 {
                return paymentModel.paidPayments.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PendingCell") as! PendingPaymentCellView
            let data = paymentModel!.pendingPayments[indexPath.row]
            cell.setup(data.name, data.description, data.amount)
            cell.delegate = self
            cell.index = indexPath.row
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaidCell") as! PaidPaymentCellView
            let data = paymentModel!.paidPayments[indexPath.row]
            cell.setup(data.name, data.description, data.amount)
            cell.delegate = self
            cell.tableView = (self.view as! PaymentView).tableView
            return cell
        default:
            fatalError("TableView was ask for cell for unexpected section with number: \(indexPath.section)")
        }
        
    }
    
}
