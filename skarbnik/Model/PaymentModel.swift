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

class PaymentModel {
    
    var child: Child?
    var paymentsArr: [Payment] = [Payment]()
    
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
                        print("Response 200 OK")
                        
                        for paymentData in try! self.decoder.decode([PaymentPacket].self, from: data) {
                            self.paymentsArr.append(Payment(data: paymentData))
                        }
                        
                        self.paymentsArr.sort(by: { (payment1, payment2) -> Bool in
                            return payment1.start_date.compare(payment2.start_date) == .orderedDescending
                        })
                        
                        //get more info about contributions
                        class PaymentDetail: Codable {
                            let amount_paid: String
                        }
                        
                        for var payment in self.paymentsArr {
                            let paymentDetailEndpoint: URLComponents = {
                                var url = URLComponents()
                                
                                url.scheme = "https"
                                url.host = "quiet-caverns-69534.herokuapp.com"
                                url.port = 443
                                url.path = "/api/paymentdetail/"
                                url.queryItems = [  URLQueryItem(name: "payment", value: String(payment.id_field)),
                                                    URLQueryItem(name: "student", value: String(child.id_field))]
                                
                                return url
                            }()
                            let getPaymentDetailRequest: URLRequest! = {
                                var request = URLRequest(url: paymentDetailEndpoint.url!)
                                
                                request.httpMethod = "GET"
                                request.addValue("Basic" + " " + UserDefaults.standard.string(forKey: "JWT")!, forHTTPHeaderField: "Authorization")
                                
                                return request
                            }()
                            
                            let getPaymentDetailTask = self.session.dataTask(with: getPaymentDetailRequest, completionHandler: { (data, response, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    if let data = data, let response = response {
                                        do {
                                            let paymentDetailArr = try self.decoder.decode([PaymentDetail].self, from: data)
                                            
                                            for  paymentDetail in paymentDetailArr {
                                                if payment.contribution == nil {
                                                    payment.contribution = [Float(paymentDetail.amount_paid)!]
                                                } else {
                                                    payment.contribution?.append(Float(paymentDetail.amount_paid)!)
                                                }
                                            }
                                            //print(payment.contribution)
                                        } catch {
                                            print(error)
                                        }
                                        
                                        
                                    }
                                }
                            })
                            getPaymentDetailTask.resume()
                        }
                        
                        
                        
                        
                        completion()
                        
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
