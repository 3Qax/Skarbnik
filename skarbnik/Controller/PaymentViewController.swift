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
        self.present(classPickViewController, animated: true)
        
        (self.view as! PaymentView).tableView.delegate = self
        (self.view as! PaymentView).tableView.dataSource = self
    }
}

extension PaymentViewController: PickerProtocol {
    func didChoose(at: Int) {
        (self.view as! PaymentView).viewForUser(name: userModel!.children![at].name, className: userModel!.children![at].class_field.name)
        paymentModel = PaymentModel(forClassId: userModel!.children![at].class_field.id_field, completion: {
            DispatchQueue.main.async {
                (self.view as! PaymentView).tableView.reloadData()
            }
        })
    }
}

extension PaymentViewController: UITableViewDelegate {
    
}

extension PaymentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentModel?.paymentsArr.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payment") as! PaymentCell
        cell.setup(forPayment: (paymentModel?.paymentsArr[indexPath.row])!)
        return cell
    }
}
