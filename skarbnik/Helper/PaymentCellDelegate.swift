//
//  PaymentCellDelegate.swift
//  skarbnik
//
//  Created by Jakub Towarek on 11/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation



protocol PaymentCellDelegate {
    func didTapRemindButton(sender: PaymentCell)
    func didTapPayButton(sender: PaymentCell)
    func didTapMoreButton(sender: PaymentCell)
}
