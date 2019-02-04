//
//  PaymentModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 04/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

class PaymentModel {
    private let apiClient       = APIClient()
    public var pendingPayments  = [Payment]()
    public var paidPayments     = [Payment]()
    private var recivedPayments = [Payment]()
    
    struct PaymentPacket: Codable {
        let id_field: Int
        let name, description: String
        let amount: String
        let creation_date, start_date, end_date: String
    }
    
    struct Payment: Codable {
        let id_field: Int
        let name, description: String
        let amount: Float
        let creation_date, start_date, end_date: Date
        var contribution: [Float]?
        
        init(data: PaymentPacket) {
            self.id_field = data.id_field
            self.name = data.name
            self.description = data.description
            self.amount = Float(data.amount)!
            
            let longDateFormatter = ISO8601DateFormatter()
            self.creation_date = longDateFormatter.date(from: data.creation_date)!
            
            let shortDateFormater = DateFormatter()
            shortDateFormater.dateFormat = "yyyy-MM-dd"
            self.start_date = shortDateFormater.date(from: data.start_date)!
            self.end_date = shortDateFormater.date(from: data.end_date)!
        }
    }
    
    func refreshData(completion: () -> ()) {
        
    }
    
    init(of: Int) {
        
    }
    
}
