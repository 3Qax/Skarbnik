//
//  userModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 19/12/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import Foundation

struct User: Codable {
    let username: String
    let name: String
    let email: String
    let role: Int
}

class UserModel {
    var user: User?
    
    private var destinationURL = URLComponents()
    private var session: URLSession = {
        var configuration: URLSessionConfiguration! = {
            let config = URLSessionConfiguration.default
            config.allowsCellularAccess = false
            config.waitsForConnectivity = true
            return config
        }()
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    private func parseResponse(data: Data) {
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try! decoder.decode(User.self, from: data)
        print("\tLoaded user: \(user)")
    }
    
    init() {
        //tworzenia URL
        destinationURL.scheme = "https"
        destinationURL.host = "quiet-caverns-69534.herokuapp.com"
        destinationURL.port = 443
        destinationURL.path = "/api/users/current/"
        
        //tworzenie URLRequest bazująze na URL
        let request:URLRequest! = {
            var request = URLRequest(url: destinationURL.url!)
            request.httpMethod = "GET"
            request.addValue("Basic" + " " + UserDefaults.standard.string(forKey: "JWT")!, forHTTPHeaderField: "Authorization")
            return request
        }()
        
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode==200 {
                        self.parseResponse(data: data)
                    } else {
                        print("\(response.statusCode) while trying to get user data")
                    }
                }
            }
        }
        task.resume()
    }
}
