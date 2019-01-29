//
//  PaymentViewPaidPaymentCellController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 16/01/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

//MARK: 
extension PaymentViewController: PaidPaymentCellProtocool {
    func didTapped(sender: PaidPaymentCellView) {
        sender.toggle()
    }
    
}
