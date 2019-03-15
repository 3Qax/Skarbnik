//
//  PayModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 13/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation




class PayModel {
    let remittances: [Float]
    let paymentName: String
    
    init(of name: String, remittances: [Float]) {
        self.paymentName = name
        self.remittances = remittances
    }
}
