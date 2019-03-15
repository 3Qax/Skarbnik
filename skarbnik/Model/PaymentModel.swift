//
//  PaymentModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 04/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

class PaymentModel {
    private let apiClient           = APIClient()
    private let dispatchGroup       = DispatchGroup()
    private var onRefreshCompletion: () -> () = { print("refreshing ended") }
    private let classID: Int
    private let studentID: Int
    public  var pendingPayments     = [Int: Payment]() {
        didSet {
            if pendingPayments.count > 0 { NotificationCenter.default.post(name: .modelChangedPendingPayemnts, object: self) }
        }
    }
    public  var paidPayments        = [Int: Payment]() {
        didSet {
            if paidPayments.count > 0 { NotificationCenter.default.post(name: .modelChangedPaidPayemnts, object: self) }
        }
    }
    private var recivedPayments     = [Payment]()
    
    struct PaymentPacket: Codable {
        let id_field: Int
        let creation_date, start_date, end_date: String
        let amount, currency: String
        let name, description: String
        let image: String?
    }
    
    class Payment {
        private weak var paymentModel: PaymentModel?
        let id_field: Int
        let name, description: String
        let amount: Float
        let currency: String
        let creation_date, start_date, end_date: Date
        var contribution: [Float] = [Float]()
        var image: Data?
        
        func encode<T: Encodable>(_ data: T) -> Data {
            return try! JSONEncoder().encode(data)
        }
        
        func decode<T: Decodable>(_: T.Type, from data: Data) -> T {
            return try! JSONDecoder().decode(T.self, from: data)
        }
        
        init(data: PaymentPacket, paymentModel: PaymentModel) {
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
            
            self.paymentModel = paymentModel
            
            self.fetchContributions()
            if data.image != nil {
                self.fetchImage()
            }
        }
        
        func fetchContributions() {
            
            class PaymentDetail: Codable {
                let amount_paid: String
            }
            
            paymentModel!.apiClient.request(.paymentDetail,
                               queryItems: [URLQueryItem(name: "payment", value: String(id_field)),
                                            URLQueryItem(name: "student", value: String(paymentModel!.studentID))],
                               completion: { (succeed, data) in
                                guard succeed else {
                                    print("Getting contributions of Payment: \(self.id_field) failed!")
                                    return
                                }
                                if let data = data {
                                    let recivedDetails = self.decode([PaymentDetail].self, from: data)
                                    for detail in recivedDetails {
                                        self.contribution.append(Float(detail.amount_paid) ?? 0)
                                    }
                                    self.classify()
                                }
            })
        }
        
        func fetchImage() {
            print("image")
        }
        
        func classify() {
            let sum = contribution.reduce(0, +)
            if sum  == amount {
                paymentModel!.paidPayments[paymentModel!.paidPayments.count] = self
            } else {
                paymentModel!.pendingPayments[paymentModel!.pendingPayments.count] = self
            }
            paymentModel!.dispatchGroup.leave()
        }
    }
    
    func encode<T: Encodable>(_ data: T) -> Data {
        return try! JSONEncoder().encode(data)
    }
    
    func decode<T: Decodable>(_: T.Type, from data: Data) -> T {
        return try! JSONDecoder().decode(T.self, from: data)
    }
    
    init(of studentID:Int, in classID: Int) {
        self.studentID = studentID
        self.classID = classID
        fetchPayments()
    }
    
    func refreshData(deletedDataHandler: () -> (), completion: @escaping () -> ()) {
        
        pendingPayments.removeAll(keepingCapacity: true)
        paidPayments.removeAll(keepingCapacity: true)
        recivedPayments.removeAll(keepingCapacity: true)
        deletedDataHandler()
        
        self.onRefreshCompletion = completion
        
        fetchPayments()
        
    }
    
    func fetchPayments() {
        apiClient.request(.payment,
                          queryItems: [URLQueryItem(name: "class_field", value: String(classID))],
                          completion: ({ (succeed, data) in
                            guard succeed else {
                                fatalError("faild getting data")
                            }
                            
                            //First parse data as PaymentPacket then create Payments based on that data
                            //This is required due to Date Type handeling dinffrence between Backend and Swift
                            let recivedPaymentsPackets = self.decode([PaymentPacket].self, from: data!)
                            for paymentPacket in recivedPaymentsPackets {
                                self.dispatchGroup.enter()
                                self.recivedPayments.append(Payment(data: paymentPacket, paymentModel: self))
                            }
                            
                            self.dispatchGroup.notify(queue: .main) {
                                self.onRefreshCompletion()
                            }
                            
                          }))

    }
    
}
