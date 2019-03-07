//
//  PaymentViewPendingPaymentCellController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 16/01/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import EventKit

//MARK:
extension PaymentViewController: PendingPaymentCellProtocool {
    func didTappedRemindButton(sender: PendingPaymentCellView) {
        
        coordinator?.didRequestReminder(about: (paymentModel.pendingPayments[sender.key!]?.name)!,
                                        ending: (paymentModel.pendingPayments[sender.key!]?.end_date)!)

    }
    
}
