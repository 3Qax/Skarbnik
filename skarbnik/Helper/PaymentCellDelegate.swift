//
//  PaymentCellDelegate.swift
//  skarbnik
//
//  Created by Jakub Towarek on 11/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation



protocol PaymentCellDelegate {
    func didTapRemind(sender: PaymentCellView)
    func didTapPay(sender: PaymentCellView)
    func didTapCell(sender: PaymentCellView)
    //func didTapCell(sender: PaymentCellView)
}
