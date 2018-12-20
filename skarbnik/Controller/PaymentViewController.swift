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
    let userModel = UserModel()
    let cellController = CellController()
    let paymentModel = PaymentModel()
    
    private var documentObserver: NSObjectProtocol?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        documentObserver = NotificationCenter.default.addObserver(
            forName: .UserInfoDidChange,
            object: nil,
            queue: OperationQueue.main,
            using: { (notification) in
                print("User info refreshed!")
                (self.view as! PaymentView).shouldReloadHeader(for: self.userModel.user!.name)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        view = PaymentView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.view as! PaymentView).tableView.delegate = self
        (self.view as! PaymentView).tableView.dataSource = self
        userModel.reload()
        
        

        cellController.loadCells { (paymentsArr) in
            DispatchQueue.main.async(execute: {
                self.paymentModel.paymentsArr = paymentsArr
                (self.view as! PaymentView).tableView.reloadData()
                print("loaded cells!")
            })
        }
    }
}

extension PaymentViewController: UITableViewDelegate {
    
}

extension PaymentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentModel.paymentsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payment") as! PaymentCell
        cell.setup(forPayment: paymentModel.paymentsArr[indexPath.row])
        return cell
    }
}
