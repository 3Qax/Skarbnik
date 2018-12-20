//
//  PaymentModel.swift
//  tableviewtest
//
//  Created by Jakub Towarek on 22/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit

struct Payment: Codable {
    var name, description: String
    var amount: String
    var creationDate: String?
    var startDate, expirationDate: String?
    //var isPaid: Bool
}

class PaymentModel: NSObject {
    var paymentsArr: [Payment] = [Payment]()
}
//class Payment: Codable {
//    var title, description, daysLeftText: String
//    var amount: Float
//    var creationDate, startDate, expirationDate: Date
//    var isPaid: Bool
//
//    init(title: String, description: String, amount: Float, creationDate: Date, startDate: Date, expirationDate: Date, isPaid: Bool) {
//        self.title = title
//        self.description = description
//        self.amount = amount
//        self.creationDate = creationDate
//        self.startDate = startDate
//        self.expirationDate = expirationDate
//        self.isPaid = isPaid
//        let daysLeft: Int? = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: self.expirationDate)).day
//        if let daysLeft = daysLeft {
//            if daysLeft > 0{
//                self.daysLeftText = String(daysLeft) + " dni pozostało"
//            }else if daysLeft==0{
//                self.daysLeftText = "do jutra"
//            }else{
//                self.daysLeftText = "zakończono"
//            }
//        } else {
//            self.daysLeftText = "Found nil when calculating"
//        }
//    }
//}
