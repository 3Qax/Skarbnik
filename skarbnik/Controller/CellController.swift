//
//  cellController.swift
//  skarbinik
//
//  Created by Jakub Towarek on 24/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit
import SCLAlertView

class CellController {
    
    var destinationURL: URLComponents = URLComponents()
    var session: URLSession = {
        var configuration: URLSessionConfiguration! = {
            let config = URLSessionConfiguration.default
            config.allowsCellularAccess = false
            config.waitsForConnectivity = true
            return config
        }()
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    func parseResponse(data: Data, completion: ([Payment]) -> ()) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        //decoder.dateDecodingStrategy = .iso8601
        let payment = try! decoder.decode([Payment].self, from: data)
        print("\tLoaded cells : \(payment)")
        completion(payment)
    }
    
    func loadCells(completion: @escaping ([Payment]) -> ()) {
        
        //tworzenia URL
        destinationURL.scheme = "https"
        destinationURL.host = "quiet-caverns-69534.herokuapp.com"
        destinationURL.port = 443
        destinationURL.path = "/api/payment/"
        print("\tTrying to load payments from URL: \(String(describing: destinationURL.url))")
        
        //tworzenie URLRequest bazująze na URL
        let request:URLRequest! = {
            var request = URLRequest(url: destinationURL.url!)
            request.httpMethod = "GET"
            request.addValue("Basic" + " " + UserDefaults.standard.string(forKey: "JWT")!, forHTTPHeaderField: "Authorization")
            return request
        }()
        
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async(execute: {
                    print(error.localizedDescription)
                    SCLAlertView().showError("Błąd", subTitle: "\(error.localizedDescription)", closeButtonTitle: "nah")
                })
            } else {
                if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode==200 {
                        print("Response 200 OK")
                        DispatchQueue.main.async(execute: {
                            self.parseResponse(data: data, completion: completion)
                        })
                    } else {
                        DispatchQueue.main.async(execute: {
                            SCLAlertView().showError("Błąd", subTitle: "HTTP Code - \(response.statusCode) while trying to fetch payment data", closeButtonTitle: "nah")
                        })
                    }
                }
            }
        }
        task.resume()
    }
}
