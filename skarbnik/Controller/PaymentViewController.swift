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
    let userModel: UserModel? = UserModel { (_) in
        print("lunched successfully")
    }
    var paymentModel: PaymentModel?
    let eventStore = EKEventStore()
    let studentPicker = UIAlertController(title: nil,
                                          message: NSLocalizedString("choose_student_description", comment: ""),
                                          preferredStyle: .actionSheet)
    var selectedChild: Child?
    
    
    
    override func loadView() {
        view = PaymentView(frame: UIScreen.main.bounds)
    }
    
    func didChoose(id: Int, completion: @escaping () -> ()) {
        selectedChild = userModel!.children?.first(where: { (child) -> Bool in
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
        
        //don't allow user to change student while loading one
        (self.view as! PaymentView).headerChangeStudentImageView.isUserInteractionEnabled = false
        (self.view as! PaymentView).headerChangeStudentImageView.alpha = 0.3
        
        for child in userModel!.children! {
            studentPicker.addAction(UIAlertAction(title: "\(child.name)", style: .default, handler: { (_) in
                selectionFeedbackGenerator.selectionChanged()
                //TODO: show some amazing endless animation of loading
                self.didChoose(id: child.id_field, completion: {
                    //TODO: stop that amazing animation
                    notificationFeedbackGenerator.notificationOccurred(.success)
                    (self.view as! PaymentView).headerChangeStudentImageView.isUserInteractionEnabled = true
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                        (self.view as! PaymentView).blurView.alpha = 0.0
                        (self.view as! PaymentView).headerChangeStudentImageView.alpha = 1
                    })
                    
                })
                self.studentPicker.dismiss(animated: false)
            }))
        }
        selectionFeedbackGenerator.prepare()
        self.present(studentPicker, animated: true)
        
        (self.view as! PaymentView).tableView.dataSource = self
        (self.view as! PaymentView).tableView.delegate = self
        (self.view as! PaymentView).delegate = self
    }
}

extension PaymentViewController: PaymentViewProtocol {
    
    //provide selectedChild changing functionality
    func didTappedClass() {
        (self.view as! PaymentView).headerChangeStudentImageView.isUserInteractionEnabled = false
        selectionFeedbackGenerator.selectionChanged()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            (self.view as! PaymentView).blurView.alpha = 1.0
            (self.view as! PaymentView).headerChangeStudentImageView.alpha = 0.3
        })
        selectionFeedbackGenerator.prepare()
        self.present(studentPicker, animated: true)
    }
    
    //refresh data for selectedChild
    func refreshData(completion: @escaping () -> ()) {
        //TODO: model should recived and shown payemnts in separate arrays
//        paymentModel = PaymentModel(for: selectedChild!, completion: {
//            DispatchQueue.main.async {
//                (self.view as! PaymentView).tableView.reloadData()
                completion()
//            }
//        })
    }
}

//MARK:
extension PaymentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
            print(indexPath.row)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Will display \(String(describing: tableView.indexPath(for: cell)?.item))")
    }
}
