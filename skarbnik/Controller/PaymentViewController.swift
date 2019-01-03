//
//  PaymentView.swift
//  skarbinik
//
//  Created by Jakub Towarek on 24/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit
import Material

class PaymentViewController: UIViewController {
    var paymentModel: PaymentModel?
    let classPickViewController = ClassPickViewController()
    
    
    
    override func loadView() {
        view = PaymentView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classPickViewController.delegate = self
        classPickViewController.modalPresentationStyle = .overCurrentContext
        self.present(classPickViewController, animated: false)
        
        (self.view as! PaymentView).tableView.delegate = self
        (self.view as! PaymentView).tableView.dataSource = self
        (self.view as! PaymentView).delegate = self
    }
}

extension PaymentViewController: PaymentViewProtocol {
    func didTappedClass() {
        self.present(classPickViewController, animated: false)
    }
}

extension PaymentViewController: PickerProtocol {
    func didChoose(_ index: Int, completion: @escaping () -> ()) {
        
        (self.view as! PaymentView).viewFor(child: userModel!.children![index])
        
        paymentModel = PaymentModel(for: userModel!.children![index], completion: {
            DispatchQueue.main.async {
                (self.view as! PaymentView).tableView.reloadData()
                completion()
            }
        })
        
    }
}

extension PaymentViewController: UITableViewDelegate {
    
}

extension PaymentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Pending"
        } else if section == 1 {
            return "Paid"
        }
        return "Wuut"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "payment") as! PaymentCell
        if indexPath.section == 0 {
            cell.setup(forPayment: (paymentModel?.pendingPayments[indexPath.row])!)
        } else if indexPath.section == 1 {
            cell.setup(forPayment: (paymentModel?.paidPayments[indexPath.row])!)
        }
        return cell
    }
}
