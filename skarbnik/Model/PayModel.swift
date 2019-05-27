//
//  PayModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 13/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation




class PayModel {
    let payment: Payment
    let apiClient = APIClient()
    
    var amountLeftToPay: Float {
        get {
            return payment.amount - payment.contribution.map({ $0.amount }).reduce(0, +)
        }
    }
    
    struct PayPacket: Codable {
        let payment: Int
        let student: Int
        let amount_paid: Float
        
        init(payment: Int, student: Int, amount_paid: Float) {
            self.payment = payment
            self.student = student
            self.amount_paid = amount_paid
        }
    }
    
    init(of payment: Payment) {
        self.payment = payment
    }
    
    func pay(_ value: Float) {
//        let payPacket = PayPacket(payment: payment.id_field, student: payment., amount_paid: 2.0)
//        apiClient.post(payPacket, to: APIClient.Endpoint.paymentDetail) { (result: APIClient.Result<>) in
//            <#code#>
//        }
    }
}
