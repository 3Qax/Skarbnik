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
            if contribution.reduce(0, +) == amount { return .paid }
            if Date() < start_date { return .awaiting }
            return .pending
        }
    }
    var leftToPay: Float {
        get {
            return amount - contribution.reduce(0, +)
        }
    }
    
    enum PaymentState: Int {
        case awaiting = 1
        case pending = 2
        case paid = 3
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
    
}
