//
//  PaymentModel.swift
//  tableviewtest
//
//  Created by Jakub Towarek on 22/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit

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

class PaymentModelOld {
    
    var child: Child?
    var pendingPayments: [Payment] = [Payment]()
    var paidPayments: [Payment] = [Payment]()
    
    let decoder = JSONDecoder()
    let session: URLSession = {
        var configuration: URLSessionConfiguration! = {
            let config = URLSessionConfiguration.default
            
            config.allowsCellularAccess = true
            config.waitsForConnectivity = true
            
        return config
        }()
    let session = URLSession(configuration: configuration)
    return session
    }()
    

    
    init(for child: Child, completion: @escaping () -> ()) {
        self.child = child
        
        let paymentEndpoint: URLComponents = {
            var url = URLComponents()
            
            url.scheme = "https"
            url.host = "quiet-caverns-69534.herokuapp.com"
            url.port = 443
            url.path = "/api/payment/"
            url.queryItems = [URLQueryItem(name: "class_field", value: String(child.class_field.id_field))]
            
            return url
        }()
        let getClassPaymentsRequest: URLRequest! = {
            var request = URLRequest(url: paymentEndpoint.url!)
            
            request.httpMethod = "GET"
            request.addValue("Basic" + " " + UserDefaults.standard.string(forKey: "JWT")!, forHTTPHeaderField: "Authorization")
            return request
        }()
        
        let getClassPaymentsTask = session.dataTask(with: getClassPaymentsRequest) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode==200 {
                        
                        //Create array of payments from data recived
                        var recivedPayments: [Payment] = [Payment]()
                        for paymentData in try! self.decoder.decode([PaymentPacket].self, from: data) {
                            recivedPayments.append(Payment(data: paymentData))
                        }
                        
                        //For every payment make a network call for contributions
                        let dispatchGroup = DispatchGroup()
                        class PaymentDetail: Codable {
                            let amount_paid: String
                        }
                        for index in 0..<recivedPayments.count {
                            let paymentDetailEndpoint: URLComponents = {
                                var url = URLComponents()
                                
                                url.scheme = "https"
                                url.host = "quiet-caverns-69534.herokuapp.com"
                                url.port = 443
                                url.path = "/api/paymentdetail/"
                                url.queryItems = [  URLQueryItem(name: "payment", value: String(recivedPayments[index].id_field)),
                                                    URLQueryItem(name: "student", value: String(child.id_field))]
                                
                                return url
                            }()
                            let getPaymentDetailRequest: URLRequest! = {
                                var request = URLRequest(url: paymentDetailEndpoint.url!)
                                
                                request.httpMethod = "GET"
                                request.addValue("Basic" + " " + UserDefaults.standard.string(forKey: "JWT")!, forHTTPHeaderField: "Authorization")
                                
                                return request
                            }()
                            
                            dispatchGroup.enter()
                            let getPaymentDetailTask = self.session.dataTask(with: getPaymentDetailRequest, completionHandler: { (data, response, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    if let data = data, let response = response as? HTTPURLResponse {
                                        if response.statusCode == 200 {
                                            do {
                                                let paymentDetailArr = try self.decoder.decode([PaymentDetail].self, from: data)
                                                
                                                for  paymentDetail in paymentDetailArr {
                                                    if recivedPayments[index].contribution == nil {
                                                        recivedPayments[index].contribution = [Float(paymentDetail.amount_paid)!]
                                                    } else {
                                                        recivedPayments[index].contribution?.append(Float(paymentDetail.amount_paid)!)
                                                    }
                                                }
                                                //print("Payment: \(recivedPayments[index].id_field) fetched contributions: \(String(describing: recivedPayments[index].contribution)) - \(response.statusCode)")
                                                dispatchGroup.leave()
                                            } catch {
                                                print(error)
                                            }
                                        } else {
                                            print("\(response.statusCode) while trying to get details of payment \(recivedPayments[index].id_field)")
                                        }
                                    }
                                }
                            })
                            getPaymentDetailTask.resume()
                        }
                        
                        //After every call ends sort recivedPayments into pending and paid payments
                        //  based on contributions
                        dispatchGroup.notify(queue: .main, execute: {
                            for recivedPayment in recivedPayments {
                                let amountPaid: Float = {
                                    var sum: Float = 0.0
                                    
                                    if let contributions = recivedPayment.contribution {
                                        for contribution in contributions {
                                            sum += contribution
                                        }
                                    }
                                    
                                    return sum
                                }()
//                                print("Amont paid of \(recivedPayment.id_field) = \(amountPaid)/\(recivedPayment.amount)")
                                if amountPaid == recivedPayment.amount {
                                    self.paidPayments.append(recivedPayment)
                                } else {
                                    self.pendingPayments.append(recivedPayment)
                                }
                                
                                
                                self.paidPayments.sort(by: { (payment1, payment2) -> Bool in
                                    return payment1.start_date.compare(payment2.start_date) == .orderedDescending
                                })
                                self.pendingPayments.sort(by: { (payment1, payment2) -> Bool in
                                    return payment1.start_date.compare(payment2.start_date) == .orderedDescending
                                })
                            }
                            completion()
                        })
                        
                    } else {
                        print("HTTP Code: \(response.statusCode) while trying to fetch payment data")
                    }
                }
            }
        }
        
        getClassPaymentsTask.resume()
    }
}
    
    



//        self.creationDate = creationDate
//        self.startDate = startDate
//        self.expirationDate = expirationDate
//        let daysLeft: Int? = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: self.expirationDate)).day
//        if let daysLeft = daysLeft {
//            if daysLeft > 0{
//                self.daysLeftText = String(daysLeft) + " dni pozostało"
//            } else if daysLeft == 0 {
//                self.daysLeftText = "do jutra"
//            } else {
//                self.daysLeftText = "zakończono"
//            }
//        } else {
//            self.daysLeftText = "Found nil when calculating"
//        }
//    }
//}
