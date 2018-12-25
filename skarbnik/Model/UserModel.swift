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

class UserModel {
    private var token: String? = UserDefaults.standard.string(forKey: "JWT") {
        didSet {
            UserDefaults.standard.set(token, forKey: "JWT")
        }
    }//token required to authorize self
    var user: User? //user object represents a parent
    var children: [Child]? //children array represents parent's children
    var didLoginSuccessfully = false
    
    private let decoder = JSONDecoder()
    private var session: URLSession = {
        var configuration: URLSessionConfiguration! = {
            let config = URLSessionConfiguration.ephemeral
            config.allowsCellularAccess = true
            config.waitsForConnectivity = true
            return config
        }()
        return URLSession(configuration: configuration)
    }()
    
    private let userLoginWithCredentialsEndpoint: URLComponents = {
        var url = URLComponents()
        
        url.scheme = "https"
        url.host = "quiet-caverns-69534.herokuapp.com"
        url.port = 443
        url.path = "/api/users/login"
        
        return url
    }()
    private let userLoginWithTokenEndpoint: URLComponents = {
        var url = URLComponents()
        
        url.scheme = "https"
        url.host = "quiet-caverns-69534.herokuapp.com"
        url.port = 443
        url.path = "/api/users/refresh"
        
        return url
    }()
    private let userInfoEndpoint: URLComponents = {
        var url = URLComponents()
        
        url.scheme = "https"
        url.host = "quiet-caverns-69534.herokuapp.com"
        url.port = 443
        url.path = "/api/users/current/"
        
        return url
    }()
    //This endpoint have to specify user_id which relie on
    //  getting user object successfully so it should be
    //  initialized after successfully reciving it
    private lazy var childrenInfoEndpoint: URLComponents = {
        var url = URLComponents()
        
        url.scheme = "https"
        url.host = "quiet-caverns-69534.herokuapp.com"
        url.port = 443
        url.path = "/api/student/"
        guard user != nil else {
            fatalError("A user object have to initialized befeore creating endpoint for getting his/her children")
        }
        url.queryItems = [URLQueryItem(name: "user", value: String(user!.id_field))]
        
        return url
    }()
    
    
    
    init(completion: @escaping (Bool) -> ()) {
        login { (succeed) in
            guard succeed else {
                completion(false)
                return
            }
            
            let userInfoRequest:URLRequest! = {
                var request = URLRequest(url: self.userInfoEndpoint.url!)
                request.httpMethod = "GET"
                request.addValue("Basic" + " " + self.token!, forHTTPHeaderField: "Authorization")
                return request
            }()
            let getUserInfoTask = self.session.dataTask(with: userInfoRequest) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let data = data, let response = response as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            print("Got user info")
                            self.user = try! self.decoder.decode(User.self, from: data)
                            getChildrenInfo()
                        } else {
                            print("\(response.statusCode) while trying to get user data")
                        }
                    }
                }
            }
            getUserInfoTask.resume()
            func getChildrenInfo() {
                let childrenRequest:URLRequest! = {
                    var request = URLRequest(url: self.childrenInfoEndpoint.url!)
                    request.httpMethod = "GET"
                    request.addValue("Basic" + " " + self.token!, forHTTPHeaderField: "Authorization")
                    return request
                }()
                
                let getChildrenInfoTask = self.session.dataTask(with: childrenRequest) { (data, response, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let data = data, let response = response as? HTTPURLResponse {
                            if response.statusCode == 200 {
                                //print(String(data: data, encoding: .utf8)!)
                                print("Got user's children info")
                                self.children = try! self.decoder.decode([Child].self, from: data)
                                completion(true)
                            } else {
                                print("\(response.statusCode) while trying to get user's children data")
                            }
                        }
                    }
                }
                getChildrenInfoTask.resume()
            }
            self.didLoginSuccessfully = true
        }
    }
    
    init(login: String?, password: String?, initCompletion: @escaping (Bool) -> ()) {
        self.login(login: login, password: password) { (succeed) in
            guard succeed else {
                initCompletion(false)
                return
            }
            
            let userInfoRequest:URLRequest! = {
                var request = URLRequest(url: self.userInfoEndpoint.url!)
                request.httpMethod = "GET"
                request.addValue("Basic" + " " + self.token!, forHTTPHeaderField: "Authorization")
                return request
            }()
            let getUserInfoTask = self.session.dataTask(with: userInfoRequest) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let data = data, let response = response as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            print("Got user info")
                            self.user = try! self.decoder.decode(User.self, from: data)
                            getChildrenInfo()
                        } else {
                            print("\(response.statusCode) while trying to get user data")
                        }
                    }
                }
            }
            getUserInfoTask.resume()
            func getChildrenInfo() {
                let childrenRequest:URLRequest! = {
                    var request = URLRequest(url: self.childrenInfoEndpoint.url!)
                    request.httpMethod = "GET"
                    request.addValue("Basic" + " " + self.token!, forHTTPHeaderField: "Authorization")
                    return request
                }()
                
                let getChildrenInfoTask = self.session.dataTask(with: childrenRequest) { (data, response, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let data = data, let response = response as? HTTPURLResponse {
                            if response.statusCode == 200 {
                                //print(String(data: data, encoding: .utf8)!)
                                print("Got user's children info")
                                self.children = try! self.decoder.decode([Child].self, from: data)
                                initCompletion(true)
                            } else {
                                print("\(response.statusCode) while trying to get user's children data")
                            }
                        }
                    }
                }
                getChildrenInfoTask.resume()
            }
            self.didLoginSuccessfully = true
        }
    }
    
    func handleLoginResponse(response: HTTPURLResponse, data: Data, completion: @escaping (Bool) -> ()){
        
        struct ResponsePacket: Codable {
            let token: String
        }
        
        switch response.statusCode {
        case 200:
            print("Loged in successfully")
            let responseData: ResponsePacket = try! JSONDecoder().decode(ResponsePacket.self, from: data)
            self.token = responseData.token
            completion(true)
        default:
            print("HTTP Error: \(response.statusCode)")
            completion(false)
            return
        }
    }
    
    func login(login: String?, password: String?, completion: @escaping (Bool) -> ()) {
        if let login = login, let password = password, login != "", password != ""{
            
            struct LoginPacket: Codable {
                let username: String
                let password: String
            }
            
            let loginData = LoginPacket(username: login, password: password)
            
            let loginWithCredentialsRequest: URLRequest! = {
                //print(userLoginWithCredentialsEndpoint.url!)
                var request = URLRequest(url: userLoginWithCredentialsEndpoint.url!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try! JSONEncoder().encode(loginData)
                //print(String(data: try! JSONEncoder().encode(loginData), encoding: .utf8)!)
                return request
            }()
            
            let loginTask = session.dataTask(with: loginWithCredentialsRequest) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let data = data, let response = response as? HTTPURLResponse {
                            self.handleLoginResponse(response: response, data: data, completion: completion)
                        }
                    }
                }
            loginTask.resume()
        }
    }
    
    func login(completion: @escaping (Bool) -> ()) {
        
        guard token != nil else {
            completion(false)
            return
        }
        
        print("Found token: \(String(describing: token))")
        
        struct LoginPacket: Codable {
            let token: String
        }

        let loginWithTokenRequest: URLRequest! = {
                var request = URLRequest(url: userLoginWithTokenEndpoint.url!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try! JSONEncoder().encode(LoginPacket(token: token!))
                return request
        }()
            
        let loginTask = session.dataTask(with: loginWithTokenRequest) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let data = data, let response = response as? HTTPURLResponse {
                    self.handleLoginResponse(response: response, data: data, completion: completion)
                }
            }
        }
        loginTask.resume()
    }
    
}
