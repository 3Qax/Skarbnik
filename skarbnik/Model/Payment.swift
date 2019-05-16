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
    let images: [Image]
}

enum ImageState {
    case notLoaded
    case loading
    case loaded
    case error
}

class Image: NSObject, Codable {
    let id: Int
    let URL: String
    var data: Data?
    var state: ImageState = .notLoaded
    
    enum CodingKeys: String, CodingKey {
        case id = "id_field"
        case URL = "image"
    }
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
    var images: [Image]
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
        case awaiting = 2
        case pending = 1
        case paid = 3
    }
    
    
    
    init(data: PaymentPacket) {
        self.id_field = data.id_field
        self.name = data.name
        self.description = data.description
        self.amount = Float(data.amount)!
        self.currency = data.currency
        self.images = data.images
        
        let longDateFormatter = ISO8601DateFormatter()
        self.creation_date = longDateFormatter.date(from: data.creation_date)!
        
        let shortDateFormater = DateFormatter()
        shortDateFormater.dateFormat = "yyyy-MM-dd"
        self.start_date = shortDateFormater.date(from: data.start_date)!
        self.end_date = shortDateFormater.date(from: data.end_date)!
    }
    
}
