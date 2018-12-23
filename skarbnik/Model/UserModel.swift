//
//  userModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 19/12/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import Foundation

struct User: Codable {
    let id_field: Int
    let username: String
    let name: String
    let email: String
    let role: Int
}

struct Class: Codable {
    let id_field: Int
    let name: String
}

struct Child: Codable {
    let id_field: Int
    let class_field: Class
    let name: String
}

extension Notification.Name {
    static let UserInfoDidChange = Notification.Name(rawValue: "UserInfoDidChange")
}

//user class represents a parent
class UserModel {
    var user: User?
    var children:[Child]?
    
    private let userInfoEndpoint: URLComponents = {
        var url = URLComponents()
        
        url.scheme = "https"
        url.host = "quiet-caverns-69534.herokuapp.com"
        url.port = 443
        url.path = "/api/users/current/"
        
        return url
    }()
    private lazy var childrenInfoEndpoint: URLComponents = {
        var url = URLComponents()
        
        url.scheme = "https"
        url.host = "quiet-caverns-69534.herokuapp.com"
        url.port = 443
        url.path = "/api/student/"
        url.queryItems = [URLQueryItem(name: "user", value: String(user!.id_field))]
        
        return url
    }()
    
    private var task: URLSessionDataTask?
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
    
    private let decoder = JSONDecoder()
    
    init() {
        //tworzenie URLRequest bazująze na URL
        let userRequest:URLRequest! = {
            var request = URLRequest(url: userInfoEndpoint.url!)
            request.httpMethod = "GET"
            request.addValue("Basic" + " " + UserDefaults.standard.string(forKey: "JWT")!, forHTTPHeaderField: "Authorization")
            return request
        }()
        
        func getChildrenInfo() {
            let childrenRequest:URLRequest! = {
                var request = URLRequest(url: childrenInfoEndpoint.url!)
                request.httpMethod = "GET"
                request.addValue("Basic" + " " + UserDefaults.standard.string(forKey: "JWT")!, forHTTPHeaderField: "Authorization")
                return request
            }()
            
            let getChildrenInfoTask = session.dataTask(with: childrenRequest) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let data = data, let response = response as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            //print(String(data: data, encoding: .utf8))
                            self.children = try! self.decoder.decode([Child].self, from: data)
                            print(self.children)
                            NotificationCenter.default.post(name: .UserInfoDidChange, object: self)
                        } else {
                            print("\(response.statusCode) while trying to get user data")
                        }
                    }
                }
            }
            getChildrenInfoTask.resume()
        }
        
        let getUserInfoTask = session.dataTask(with: userRequest) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        self.user = try! self.decoder.decode(User.self, from: data)
                        getChildrenInfo()
                    } else {
                        print("\(response.statusCode) while trying to get user data")
                    }
                }
            }
        }
        getUserInfoTask.resume()
    }
}
