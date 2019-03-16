//
//  Payment.swift
//  skarbnik
//
//  Created by Jakub Towarek on 16/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation



struct PaymentPacket: Codable {
    let id_field: Int
    let creation_date, start_date, end_date: String
    let amount, currency: String
    let name, description: String
    let image: String?
}

struct PaymentDetailPacket: Codable {
    let amount_paid: String
}

final class Payment {
    let id_field: Int
    let name, description: String
    let amount: Float
    let currency: String
    let creation_date, start_date, end_date: Date
    var contribution: [Float] = [Float]()
    var image: Data?
    var state: PaymentState {
        get {
            let sum = contribution.reduce(0, +)
            if sum == amount { return .paid }
            if sum == 0 { return .pending }
            return .partialyPaid
        }
    }
    
    enum PaymentState {
        case pending
        case partialyPaid
        case paid
    }
    
    
    
    init(data: PaymentPacket) {
        self.id_field = data.id_field
        self.name = data.name
        self.description = data.description
        self.amount = Float(data.amount)!
        self.currency = data.currency
        
        let longDateFormatter = ISO8601DateFormatter()
        self.creation_date = longDateFormatter.date(from: data.creation_date)!
        
        let shortDateFormater = DateFormatter()
        shortDateFormater.dateFormat = "yyyy-MM-dd"
        self.start_date = shortDateFormater.date(from: data.start_date)!
        self.end_date = shortDateFormater.date(from: data.end_date)!
    }
    
    //        func fetchContributions() {
    //
    //            class PaymentDetail: Codable {
    //                let amount_paid: String
    //            }
    //
    //            let queryItems = [URLQueryItem(name: "payment", value: String(id_field)),
    //                              URLQueryItem(name: "student", value: String(paymentModel!.studentID))]
    //
    //            paymentModel!.apiClient.get(from: .paymentDetail, adding: queryItems) { (result: APIClient.Result<[PaymentDetail]>) in
    //                switch result {
    //                case .success(let recivedDetails):
    //                    for detail in recivedDetails {
    //                        self.contribution.append(Float(detail.amount_paid) ?? 0)
    //                    }
    //                    self.classify()
    //                case .failure(let error):
    //                    print("Getting contributions of Payment: \(self.id_field) failed!")
    //                    fatalError(error.localizedDescription)
    //                }
    //            }
    //
    //        }
    //
    //        func classify() {
    //            let sum = contribution.reduce(0, +)
    //            if sum  == amount {
    //                paymentModel!.paidPayments[paymentModel!.paidPayments.count] = self
    //            } else {
    //                paymentModel!.pendingPayments[paymentModel!.pendingPayments.count] = self
    //            }
    //            paymentModel!.dispatchGroup.leave()
    //        }
}
