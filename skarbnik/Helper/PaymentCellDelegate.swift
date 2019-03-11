//
//  PaymentCellDelegate.swift
//  skarbnik
//
//  Created by Jakub Towarek on 11/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation



protocol PaymentCellDelegate {
    func didTapRemindButton(sender: PaymentCellView)
    func didTapPayButton(sender: PaymentCellView)
    func didTapMoreButton(sender: PaymentCellView)
}
