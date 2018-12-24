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

class PaymentModel {
    
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
    
    
    
    func parseResponse(data: Data, completion: () -> ()) {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        //decoder.dateDecodingStrategy = .iso8601
        paymentsArr = try! decoder.decode([Payment].self, from: data)
        completion()
    }
    
    init(forClassId: Int, completion: @escaping () -> ()) {
        
        let paymentEndpoint: URLComponents = {
            var url = URLComponents()
            
            url.scheme = "https"
            url.host = "quiet-caverns-69534.herokuapp.com"
            url.port = 443
            url.path = "/api/payment/"
            url.queryItems = [URLQueryItem(name: "class_field", value: String(forClassId))]
            
            return url
        }()
        
        let getClassPaymentsRequest:URLRequest! = {
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
                        self.parseResponse(data: data, completion: completion)
                    } else {
                        print("HTTP Code: \(response.statusCode) while trying to fetch payment data")
                    }
                }
            }
        }
        
        getClassPaymentsTask.resume()
    }
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
