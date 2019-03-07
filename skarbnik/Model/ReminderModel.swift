//
//  ReminderModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 07/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation



class ReminderModel {
    
    let paymentName: String
    let endDate: Date
    
    var defaultReminderText: String {
        get {
            return "Zapłacić za ".capitalizingFirstLetter() + paymentName.decapitalizeingFirstLetter()
        }
    }
    
    init(paymentName: String, endDate: Date) {
        self.paymentName = paymentName
        self.endDate = endDate
        print(endDate)
    }
    
}
